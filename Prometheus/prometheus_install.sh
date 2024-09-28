SCRIPT_DIR=$(
	cd $(dirname $0)
	pwd
)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# password for grafana is:
# you can change it manually after signing in
helm upgrade --install prom prometheus-community/kube-prometheus-stack
helm upgrade --install prom prometheus-community/kube-prometheus-stack --values $SCRIPT_DIR/values.yaml
kubectl apply -f $SCRIPT_DIR/rule.yaml
