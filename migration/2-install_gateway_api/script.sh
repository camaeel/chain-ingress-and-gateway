#!/bin/bash

set -ex 

echo "install gateway API CRDs"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml


echo "install envoy gateway controller"
helm upgrade --install --namespace=envoy-gateway-system --create-namespace \
  eg oci://docker.io/envoyproxy/gateway-helm \
 --timeout 5m --wait

echo "configure enovoy gateway"
kubectl apply -f gateway-setup.yaml --wait --timeout 5m

echo "wait for envoy gateway service to get an external IP"
kubectl wait svc -n envoy-gateway-system -l gateway.envoyproxy.io/owning-gateway-name=eg --for=jsonpath='{.status.loadBalancer.ingress}' --timeout=5m

GATEWAY_LB_IP=$(kubectl get -n envoy-gateway-system svc -l gateway.envoyproxy.io/owning-gateway-name=eg -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
echo GATEWAY_LB_IP=$GATEWAY_LB_IP
