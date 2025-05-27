# Prerequisites

Install:
* docker
* kubectl
* kind
* cloud-provider-kind
* mkcert
* helm

# Install

To install all necessary resources run:
```shell
./install.sh
```

# Tests

## Install test workload

```shell
kubectl apply test-setup/namespace.yaml && kubectl apply test-setup
```
# Test gateway

Execute:
```bash
curl 'ingress-gw.test.home.kamilk.eu/get?show_env=1'
```

# Test ingress

```bash
curl -v 'https://ingress.test.home.kamilk.eu/get?show_env=1' -k
```

Have docker, kubectl, kind, cloud-provider-kind, mkcert and helm   installed
Install cloud-provider-kind with brew install cloud-provider-kind and run it with sudo DOCKER_HOST=$DOCKER_HOST cloud-provider-kind. This will start cloud-provider which will create small proxy container for each LoadBalancer service in kind cluster.
create kind cluster: kind create cluster