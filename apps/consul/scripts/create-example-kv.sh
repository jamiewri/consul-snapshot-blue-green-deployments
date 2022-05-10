#!/bin/bash
CONSUL_IP=$(kubectl get svc consul-server-external  -o json | jq -r '.status.loadBalancer.ingress[0].ip')
export CONSUL_HTTP_ADDR="http://${CONSUL_IP}:8500"

echo 'Adding KVs'
#consul kv put internalEnabled true
#consul kv put internalWeight 100

consul kv put payments/
consul kv put payments/blueEnabled true
consul kv put payments/greenEnabled true
consul kv put payments/blueWeight 1
consul kv put payments/greenWeight 1
consul kv put payments/deploymentStrategy none
