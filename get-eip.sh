#!/bin/sh

export KUBECONFIG=${1:-~/.kube/config}

# Install Kubectl if not installed
if ! [ -x "$(command -v kubectl)" ]; then
  set -e

  OS=$(uname -s)
  if [ "$OS" != "Linux" ]; then
    echo "The kubectl binary is required. Please install it manually"
    exit 1;
  fi

  wget https://dl.k8s.io/release/v1.19.13/bin/linux/amd64/kubectl 1>/dev/null
  chmod +x ./kubectl
  mv kubectl /usr/local/bin
  kubectl version 1>/dev/null
  set +e
fi

# Wait for the istio namesapce so get svc doesn't puke
until kubectl get ns istio-system 1>&- 2>&-
do
    sleep 1
done

# wait for either ip or hostname to exist 
while [ -z "$E_IP$E_HOSTNAME" ] ; do 
    sleep 1
    E_IP=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    E_HOSTNAME=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
done

# Dump as json for terraform
echo "{\"ip\":\"$E_IP\", \"hostname\":\"$E_HOSTNAME\"}"
