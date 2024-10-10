kubectl apply -f k8s-configuration/services/zookeeper-svc.yaml
kubectl apply -f k8s-configuration/services/kafka-broker-svc.yaml
kubectl apply -f k8s-configuration/services/cassandra-svc.yaml
kubectl apply -f k8s-configuration/services/app-svc.yaml

kubectl apply -f k8s-configuration/deployments/zookeeper-depl.yaml
kubectl apply -f k8s-configuration/deployments/kafka-broker-depl.yaml
kubectl apply -f k8s-configuration/deployments/cassandra-depl.yaml
kubectl apply -f k8s-configuration/deployments/api-depl.yaml
kubectl apply -f k8s-configuration/deployments/kafka-consumer-depl.yaml

sleep 5

kubectl get pods

sleep 5
kubectl apply -f k8s-configuration/deployments/app-depl.yaml