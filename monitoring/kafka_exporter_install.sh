# we use helm to install kafka exporter
#
SCRIPT_DIR=$(
	cd $(dirname $0)
	pwd
)
helm install kafka-exporter prometheus-community/prometheus-kafka-exporter -f $SCRIPT_DIR/kafka_exporter.yaml

kubectl apply -f $SCRIPT_DIR/grafana-kafka.yaml
