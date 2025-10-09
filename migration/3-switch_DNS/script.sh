#!/bin/bash

GATEWAY_LB_IP=$(kubectl get -n envoy-gateway-system svc -l gateway.envoyproxy.io/owning-gateway-name=eg -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
echo GATEWAY_LB_IP=$GATEWAY_LB_IP
echo "Replace /etc/hosts entry for demo.example.com. Execute:"
echo 'sudo sed -i "" -E "s/^[0-9\.]+[[:space:]]+demo\.example\.com.*/$GATEWAY_LB_IP demo.example.com/" /etc/hosts'

sudo sed -E "s/^[0-9\.]+[[:space:]]+demo\.example\.com.*/$GATEWAY_LB_IP demo.example.com/" /etc/hosts

echo "sudo sed -i '' -E \"s/^[0-9\.]+[[:space:]]+demo\.example\.com.*/$GATEWAY_LB_IP demo.example.com/\" /etc/hosts"
