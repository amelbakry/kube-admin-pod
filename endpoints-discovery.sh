#!/bin/bash

# Redis Endpoints

export-elasticache-endpoints() {

     clusters=$(aws elasticache describe-cache-clusters | jq '.CacheClusters[].CacheClusterId')
     for cluster in $clusters
     do
       cluster=$(echo $cluster | tr -d " \" ")
       endpoint=$(aws elasticache describe-cache-clusters \
                  --cache-cluster-id=$cluster \
                 --show-cache-node-info  | \
                 jq '.CacheClusters[].CacheNodes[].Endpoint.Address')
       endpoint=$(echo $endpoint | cut -d" " -f1 | tr -d " \" ")
       echo $cluster=$endpoint
     done
}

# RDS Endpoints

export-rds-endpoints() {
     endpoints=$(aws rds describe-db-instances | \
     jq '.DBInstances[] | "\(.DBInstanceIdentifier)= \(.Endpoint.Address)"' | tr -d " \" ")
     for endpoint in $endpoints
     do 
       echo $endpoint
     done
}

if [[ "$#" -ne 1 ]]
then
  echo "Usage ./endpoints-discovery.sh [Arg]
  Available Args are:
     rds
     cache
     "
  exit 1

elif [[ $1 == "redis" ]]
then 
 export-elasticache-endpoints

elif [[ $1 == "rds" ]]
then
  export-rds-endpoints

elif [[ $1 != "rds" || $1 != "redis" ]]
then
  echo "unsupported function"
fi
