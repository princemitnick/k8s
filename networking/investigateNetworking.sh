PODNAME=$(kubectl get pods --selector=app=nginx-prince -o jsonpath='{ .items[0].metadata.name}')

kubectl get pods



