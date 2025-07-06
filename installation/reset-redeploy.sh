##### reset.sh (à exécuter sur **chaque nœud**) #####
#!/bin/bash

set -e

# Stop kubelet and containerd
sudo systemctl stop kubelet
sudo systemctl stop containerd

# Reset kubeadm
sudo kubeadm reset -f

# Clean up Kubernetes data
sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /etc/kubernetes
sudo rm -rf ~/.kube
sudo rm -rf /opt/cni/bin

# Restart services
sudo systemctl restart containerd
sudo systemctl restart kubelet

echo "[OK] Node reset completed."


##### init-control-plane.sh (à exécuter sur le **control-plane uniquement**) #####
#!/bin/bash

set -e

# Init Kubernetes cluster with Calico subnet
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Setup kubeconfig for current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy Calico network plugin
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "[OK] Control-plane initialized and Calico installed."


##### join-worker.sh (à exécuter sur **chaque nœud worker**) #####
#!/bin/bash

# 🛑 REMPLACE cette ligne par la vraie commande générée par `kubeadm init` sur le master
# Exemple :
# sudo kubeadm join 192.168.50.10:6443 --token abcdef.0123456789abcdef \
#     --discovery-token-ca-cert-hash sha256:...

sudo kubeadm join <CONTROL-PLANE-IP>:6443 --token <TOKEN> \
    --discovery-token-ca-cert-hash sha256:<CERT-HASH>

echo "[OK] Worker node joined the cluster."
