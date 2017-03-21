#!/bin/bash

if kubectl get deploy/redis-0 &> /dev/null; then

    echo "Removing cluster"

    kubectl delete po/redis-c || true
    kubectl delete -f k8s/deployment
    kubectl delete -f k8s/service

    rm -rf k8s/deployment/deployment-*
    rm -rf k8s/service/service-*
    rm -rf k8s/tmp
else

    echo "No cluster found"
fi

