# add jetstack necessary for  k8ssandra-operator
helm repo add jetstack https://charts.jetstack.io
# add k8ssandra repo
helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm repo update

helm install cert-manager jetstack/cert-manager \
     --namespace cert-manager --create-namespace --set installCRDs=true

# install k8ssandra-operator
helm install k8ssandra-operator k8ssandra/k8ssandra-operator



# Now to run  a cassandra cluster with prometheus enables, you can change cassandra.yaml to set env variables, or to add mo datacenters
kubectl apply  -f cassandra.yaml