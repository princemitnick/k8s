#!/bin/bash

set -e

### === CONFIGURATION === ###
POD_CIDR="10.244.0.0/16"

### === SYSTEM PRE-REQUISITES === ###
echo "[1/8] ➜ Updating system and disabling swap..."
sudo apt update && sudo apt upgrade -y
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

echo "[2/8] ➜ Configuring kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

echo "[3/8] ➜ Applying sysctl settings..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

### === INSTALL CONTAINERD === ###
echo "[4/8] ➜ Installing containerd..."
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

echo "[5/8] ➜ Configuring containerd to use systemd cgroup..."
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

### === INSTALL KUBEADM, KUBELET, KUBECTL === ###
echo "[6/8] ➜ Installing Kubernetes tools..."
sudo apt install -y apt-transport-https ca-certificates curl gpg
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[7/8] ➜ All set! You can now initialize your control-plane node using:"
echo "  sudo kubeadm init --apiserver-advertise-address=<YOUR_MASTER_IP> --pod-network-cidr=${POD_CIDR}"

echo "[8/8] ➜ After init, don’t forget to apply a CNI like Flannel:"
echo "  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
