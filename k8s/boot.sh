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
    *)
    ;;
esac
done

mkdir -p k8s/tmp

if $CLEAN; then
    echo "Cleaning old env"

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

    echo "Creating node $i";
    envsubst <k8s/deployment/deployment> k8s/deployment/deployment-${INSTANCE_NUMBER}.yml;
    envsubst <k8s/service/service> k8s/service/service-${INSTANCE_NUMBER}.yml;


done

kubectl create -f k8s/deployment
kubectl create -f k8s/service

sleep 5


for i in `kubectl get svc | grep redis | awk '{print $2}'`; do

    SERVICES=$SERVICES" $i:6379"
done

echo "Bootstraping the cluster"
kubectl run -i --tty redis-c --image=jorge07/redis-trib  --restart=Never --command -- sh -c "esho 'yes' | ./redis-trib.rb create --replicas 1 $SERVICE"
