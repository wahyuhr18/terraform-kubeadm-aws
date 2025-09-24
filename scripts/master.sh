#!/bin/bash

set -euo pipefail

# Define variables for network CIDRs, API server address, and file paths
APISERVER_IP=$(hostname -I | awk '{print $1}')
POD_CIDR="192.168.0.0/16"
SERVICE_CIDR="10.96.0.0/12"

echo "[INFO] Pulling Kubernetes images..."
sudo kubeadm config images pull

echo "[INFO] Initializing Kubernetes Master Node..."
sudo kubeadm init \
  --apiserver-advertise-address="$APISERVER_IP" \
  --apiserver-cert-extra-sans="$APISERVER_IP" \
  --pod-network-cidr="$POD_CIDR" \
  --service-cidr="$SERVICE_CIDR" \
  --ignore-preflight-errors Swap

# Set up kubeconfig for user 'homelab'
echo "[INFO] Configuring kubeconfig for user 'homelab'..."
sudo -u homelab mkdir -p /home/homelab/.kube
sudo cp /etc/kubernetes/admin.conf /home/homelab/.kube/config
sudo chown homelab:homelab /home/homelab/.kube/config

# Apply the Calico Network Plugin manifest as user 'homelab'
echo "[INFO] Applying Calico network plugin..."
sudo -u homelab kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

# Wait for Calico pods to be ready
echo "[INFO] Waiting for Calico pods to be ready..."
sudo -u homelab kubectl wait --for=condition=ready pod -l k8s-app=calico-node -n kube-system --timeout=300s

echo "✅ Kubernetes master setup complete!"
