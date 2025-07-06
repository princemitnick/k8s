kubectl get nodes -o wide

# Get pod name

PODNAME=$(kubectl get pods --selector=app=app_name -o jsonpath='{ .items[0].metadata.name}')


kubectl describe pod pod_name

kubectl logs pod_name --previous

