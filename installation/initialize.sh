sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.30.0 --apiserver-advertise-address=10.244.105.197

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config






kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubeadm token create --print-join-command

kubectl get nodes

======================================================================

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubeadm join 10.244.105.197:6443 --token qeyci9.s94qyhjxu2iiq2y9 \
	--discovery-token-ca-cert-hash sha256:0250fa91b2711272b5a9f532734bd8a322e7df4c292c92b55f9e2f159a01bd13

