#/bin/bash

case $1 in
  consul)
    helm install -f ./apps/consul/values.yaml consul hashicorp/consul --version "0.32.1" --wait
    kubectl create -f ./apps/consul/service.consul-dns-internal.yaml
    kubectl create -f ./apps/consul/service.consul-server-internal.yaml
    kubectl create -f ./apps/consul/service.consul-server-external.yaml
  ;;

  consul-upgrade)
     helm upgrade -f ./apps/consul/values.yaml consul hashicorp/consul
  ;;

  consul-dns)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"consul": ["$(kubectl get svc consul-dns -o jsonpath='{.spec.clusterIP}')"]}
EOF
  ;;

  info)
    CONSUL_IP=$(kubectl get svc consul-server-external  -o json | jq -r '.status.loadBalancer.ingress[0].ip')
    echo "export CONSUL_HTTP_ADDR=http://${CONSUL_IP}:8500"
  ;;
esac


# build consul with poyhton  
#docker  build -t 'jamiewri/consul-python:1.10.1' .

