#!/bin/bash

set -ex

# install gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

# install ingress-nginx
helm upgrade --install --namespace=ingress-nginx --create-namespace \
  ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --version 4.13.3 \
  --values nginx-ingress-values.yaml --timeout 5m --wait

# install envoy-gateway
helm upgrade --install --namespace=envoy-gateway-system --create-namespace \
  eg oci://docker.io/envoyproxy/gateway-helm \
 --timeout 5m --wait

# create selfisgned certs for envoy-gateway & put them into a secret
mkcert "*.example.com"
kubectl create secret tls example-com-tls --cert=_wildcard.example.com.pem --key=_wildcard.example.com-key.pem -n envoy-gateway-system

# create gateway, gateway class and default HTTPRoute that will route trafiic not matching any other HTTProute to ingress-nginx controller
kubectl apply -f gateway-setup.yaml --wait --timeout 5m

#wait fot IP to be assigned to envoy-gateway service
kubectl wait svc -n envoy-gateway-system -l gateway.envoyproxy.io/owning-gateway-name=eg --for=jsonpath='{.status.loadBalancer.ingress[0].ip}'

GW_IP=$(kubectl get svc -n envoy-gateway-system -l gateway.envoyproxy.io/owning-gateway-name=eg -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip')

echo "add following DNS entries to /etc/hosts"
echo "$GW_IP  gw.example.com"
echo "$GW_IP  ingress.example.org"
echo "$GW_IP  notfound.example.org"
