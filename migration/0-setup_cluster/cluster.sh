#!/usr/bin/env bash

set -ex

kind get clusters | grep kind || kind create cluster

go install sigs.k8s.io/cloud-provider-kind@latest #use docker for that
echo "start cloud-provider-kind"
echo 'sudo DOCKER_HOST=$DOCKER_HOST cloud-provider-kind'


kubectl config use-context kind-kind

echo "Start cloud-provider-kind:"
echo 'sudo DOCKER_HOST=$DOCKER_HOST cloud-provider-kind'

# docker ps | grep cloud-provider-kind || docker run --rm --network host --name cloud-provider-kind -d -v /var/run/docker.sock:/var/run/docker.sock registry.k8s.io/cloud-provider-kind/cloud-controller-manager:v0.7.0



echo "Installing ingress-nginx controller"
helm upgrade --install --namespace=ingress-nginx --create-namespace \
  ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --version 4.13.3 \
  --values nginx-ingress-values.yaml --timeout 5m --wait

kubectl wait svc -n ingress-nginx ingress-nginx-controller  --for=jsonpath='{.status.loadBalancer.ingress}' --timeout=5m

LB_IP=$(kubectl get -n ingress-nginx svc/ingress-nginx-controller  -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo LB_IP=$LB_IP

echo "Add LB_IP to /etc/hosts. Execute:"
echo "echo $LB_IP \"demo.example.com\" | sudo tee -a /etc/hosts"
