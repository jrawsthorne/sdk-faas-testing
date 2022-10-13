#!/usr/bin/env bash

cluster_id=$(cbdyncluster allocate --num-nodes 1 --server-version 7.1-release --platform ec2)
cbdyncluster setup $cluster_id --node kv,index,n1ql
connstr=$(cbdyncluster connstr $cluster_id)

echo $connstr
