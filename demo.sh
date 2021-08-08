#/bin/bash

case $1 in
  consul)
    helm install -f ./apps/consul/values.yaml consul hashicorp/consul --version "0.32.1" --wait
    kubectl create -f ./apps/consul/service.consul-dns-internal.yaml
    kubectl create -f ./apps/consul/service.consul-server-internal.yaml
    kubectl create -f ./apps/consul/service.consul-server-external.yaml
    sh ./apps/consul/scripts/configure-kube-dns.sh
    sh ./apps/consul/scripts/create-example-kv.sh
  ;;

  consul-upgrade)
     helm upgrade -f ./apps/consul/values.yaml consul hashicorp/consul
  ;;

  info)
    CONSUL_IP=$(kubectl get svc consul-server-external  -o json | jq -r '.status.loadBalancer.ingress[0].ip')
    echo "export CONSUL_HTTP_ADDR=http://${CONSUL_IP}:8500"
  ;;

  dns-test)
    kubectl apply -f ./apps/consul/deployment.dns-test.yaml
  ;;

  payments)
    helm install -f ./apps/payments/values.yaml payments ./apps/payments --wait
  ;;

  payments-upgrade)
    helm upgrade -f ./apps/payments/values.yaml payments ./apps/payments 
  ;;

  upgrade-1)
    helm upgrade -f ./apps/payments/values.yaml payments ./apps/payments --set deployment.tag=1 --reset-values
  ;;

  upgrade-2)
    helm upgrade -f ./apps/payments/values.yaml payments ./apps/payments --set deployment.tag=2 --reset-values
  ;;

  loadbalancer)
    helm install -f ./apps/loadbalancer/values.yaml loadbalancer ./apps/loadbalancer --wait
  ;;

  loadbalancer-upgrade)
    helm upgrade -f ./apps/loadbalancer/values.yaml loadbalancer ./apps/loadbalancer
  ;;

  frontend)
    helm install -f ./apps/frontend/values.yaml frontend ./apps/frontend 
  ;;

  frontend-upgrade)
    helm upgrade -f ./apps/frontend/values.yaml frontend ./apps/frontend --reset-values
  ;;

  monitoring)
    helm install -f ./apps/prometheus/values.yaml prometheus prometheus-community/prometheus --version "14.0.0" --wait
    helm install -f ./apps/grafana/values.yaml grafana grafana/grafana --version "6.9.1" --wait
  ;;

  all)
    helm install -f ./apps/payments-n/values.yaml payments-green --set deployment.tag=2 --set appName=payments-green ./apps/payments-n --wait
    helm install -f ./apps/payments-n/values.yaml payments-blue --set deployment.tag=1 --set appName=payments-blue ./apps/payments-n --wait
    helm install -f ./apps/loadbalancer/values.yaml loadbalancer ./apps/loadbalancer --wait
    helm install -f ./apps/frontend/values.yaml frontend ./apps/frontend 
    helm install -f ./apps/prometheus/values.yaml prometheus prometheus-community/prometheus --version "14.0.0"
    helm install -f ./apps/grafana/values.yaml grafana grafana/grafana --version "6.9.1"
  ;;

  payments-blue)
     helm install -f ./apps/payments-n/values.yaml payments-blue --set deployment.tag=1 --set appName=payments-blue ./apps/payments-n --wait
  ;;

  payments-green-upgrade)
     helm upgrade -f ./apps/payments-n/values.yaml payments-green --set deployment.tag=2 --set appName=payments-green ./apps/payments-n --reset-values
  ;;

  payments-blue-upgrade)
     helm upgrade -f ./apps/payments-n/values.yaml payments-blue --set deployment.tag=1 --set appName=payments-blue ./apps/payments-n --reset-values
  ;;

  payments-green)
     helm install -f ./apps/payments-n/values.yaml payments-green --set deployment.tag=2 --set appName=payments-green ./apps/payments-n --wait
  ;;
esac


# build consul with poyhton  
#docker  build -t 'jamiewri/consul-python:1.10.1' .

