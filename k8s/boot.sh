#!/bin/bash

INSTANCES=6
CLEAN=true
SERVICES=''

for i in "$@"
do
case $i in
    -i=*|--instances=*)
        INSTANCES="${i#*=}"
    ;;
    ---no-clean)
        CLEAN=false
    ;;
    --help)
        echo "Kubernetes Redis cluster bootstrapping."
        echo ""
        echo "-i           Number of instances. Default -i=6"
        echo "--no-clean   Avoid remove old cluster."
        echo ""
        exit;
    ;;
    *)
    ;;
esac
done

if $CLEAN; then
    echo "Cleaning old cluster"

    if kubectl get deploy/redis-0 &> /dev/null; then

        kubectl delete po/redis-c
        kubectl delete -f k8s/deployment
        kubectl delete -f k8s/service
    fi

    rm -rf k8s/deployment/deployment-*
    rm -rf k8s/service/service-*
fi

for ((i=0;i<=INSTANCES-1;i++)); do
    export INSTANCE_NUMBER=$i;

    echo "Creating node service: $i";
    envsubst <k8s/deployment/deployment> k8s/deployment/deployment-${INSTANCE_NUMBER}.yml;
    envsubst <k8s/service/service> k8s/service/service-${INSTANCE_NUMBER}.yml;


done

kubectl create -f k8s/deployment
kubectl create -f k8s/service

echo "Waiting for ip assignations"
sleep 5

for i in `kubectl get svc | grep redis | awk '{print $2}'`; do

    SERVICES=$SERVICES" $i:6379"
done

echo "Bootstrapping the cluster"
kubectl run redis-c --image=jorge07/redis-trib --restart=Never --command -- sh -c "echo 'yes' | ./redis-trib.rb create --replicas 1 $SERVICES"
