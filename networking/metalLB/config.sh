kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

kubectl create secret generic -n metallb-system memberlist \
  --from-literal=secretkey="$(openssl rand -base64 128)"


