#!/bin/bash

# Save trace setting
XTRACE=$(set +o | grep xtrace)
set -o xtrace

K8S_VERSION=$1
DOCKER_VERSION=$2

# FIXME(mestery): Remove once Vagrant boxes allow apt-get to work again
sudo rm -rf /var/lib/apt/lists/*

# Add external repos to install docker, k8s from packages.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt-get update

## First, install docker
sudo apt-get install -y --allow-unauthenticated docker-ce=${DOCKER_VERSION}
sudo service docker start

## Install kubernetes
sudo apt-get install -y --allow-unauthenticated kubelet=${K8S_VERSION} kubeadm=${K8S_VERSION} kubectl=${K8S_VERSION}
sudo apt-mark hold kubelet kubeadm kubectl
sudo service kubelet restart
sudo swapoff -a

sudo kubeadm config images pull --kubernetes-version ${K8S_VERSION%-*}

sudo docker pull quay.io/coreos/flannel:v0.10.0-amd64

sudo rm -rf /var/lib/apt/lists/*

# Restore xtrace
$XTRACE
