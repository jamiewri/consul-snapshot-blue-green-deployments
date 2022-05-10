#!/bin/bash

case $1 in
  install)

    case $2 in
      consul)
        echo 'Installing consul'
        helm install -f ./apps/consul/values.yaml consul hashicorp/consul --version "0.32.1" --wait
        kubectl create -f ./apps/consul/service.consul-dns-internal.yaml
        kubectl create -f ./apps/consul/service.consul-server-internal.yaml
        kubectl create -f ./apps/consul/service.consul-server-external.yaml

      ;;
      consul-config)
        sh ./apps/consul/scripts/configure-kube-dns.sh
        sh ./apps/consul/scripts/create-example-kv.sh

      ;;
      payments-blue)
        echo 'Installing payments-blue'
        helm install -f ./apps/payments/deploy/values.yaml payments-blue --set deployment.tag=1 --set appName=payments-blue ./apps/payments/deploy --wait

      ;;
      payments-green)
        echo 'Installing payments-green'
        helm install -f ./apps/payments/deploy/values.yaml payments-green --set deployment.tag=2 --set appName=payments-green ./apps/payments/deploy --wait

      ;;
      loadbalancer)
         echo 'Installing loadbalancer'
         helm install -f ./apps/loadbalancer/values.yaml loadbalancer ./apps/loadbalancer --wait

      ;;
      frontend)
        echo 'Installing frontend'
        helm install -f ./apps/frontend/deploy/values.yaml frontend ./apps/frontend/deploy

      ;;
      monitoring)
        echo 'Installing monitoring'
        helm install -f ./apps/prometheus/values.yaml prometheus prometheus-community/prometheus --version "14.0.0" --wait
        helm install -f ./apps/grafana/values.yaml grafana grafana/grafana --version "6.9.1" --wait

      ;;
      dns-test)
        echo 'Installing dns-test'
        kubectl apply -f ./apps/dns-test/deployment.dns-test.yaml

      ;;
      *)
        echo 'Unknown app!'

      ;;
    esac
  ;;

  upgrade)
    case $2 in
      consul)
        echo 'Upgrading consul'
        helm upgrade -f ./apps/consul/values.yaml consul hashicorp/consul

      ;;
      payments-blue)
        echo 'Upgrading payments-blue'
        helm upgrade -f ./apps/payments/deploy/values.yaml payments-blue --set deployment.tag=1 --set appName=payments-blue ./apps/payments/deploy --reset-values

      ;;
      payments-green)
        echo 'Upgrading payments-green'
        helm upgrade -f ./apps/payments/deploy/values.yaml payments-green --set deployment.tag=2 --set appName=payments-green ./apps/payments/deploy --reset-values

      ;;
      loadbalancer)
         echo 'Upgrading loadbalancer'
         helm upgrade -f ./apps/loadbalancer/values.yaml loadbalancer ./apps/loadbalancer

      ;;
      frontend)
        echo 'Upgrading frontend'
        helm upgrade -f ./apps/frontend/deploy/values.yaml frontend ./apps/frontend/deploy --reset-values

      ;;
      *)
        echo 'Unknown app!'

      ;;
    esac
  ;;

  info)
    CONSUL_IP=$(kubectl get svc consul-server-external  -o json | jq -r '.status.loadBalancer.ingress[0].ip')
    echo "export CONSUL_HTTP_ADDR=http://${CONSUL_IP}:8500"
  ;;

  *)
    echo 'Unknown action!'
  ;;
esac
