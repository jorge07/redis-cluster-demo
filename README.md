Redis Cluster Tutorial
======================

This is the [official Redis tutorial](https://redis.io/topics/cluster-tutorial) I follow to build the cluster basically.

The redis containers are based on alpine of course and are optimized to use the minimum of possible layers to be configurable.

    docker-compose build
    docker-compose up -d
 
    docker run -it jorge07/redis-trib sh -c "echo 'yes' | ./redis-trib.rb create --replicas 1 192.168.99.100:7001 192.168.99.100:7002 192.168.99.100:7003 192.168.99.100:6000 192.168.99.100:6001 192.168.99.100:6002"
    
Done.

Testing the cluster:
       
    redis-cli -p 7001 cluster nodes
    docker kill rediscluster_master2_1
    redis-cli -p 7001 cluster nodes
    
# K8s

Require envsubst and kubectl
   
    ./k8s/boot.sh -i=NUM_INSTANCES 
