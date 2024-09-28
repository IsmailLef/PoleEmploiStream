#!/bin/bash

{
	sudo apt-get update && sudo apt-get install -y docker.io
	sudo apt-get update && sudo apt-get install -y apt-transport-https curl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	sudo swapoff -a
	sudo kubeadm init --pod-network-cidr=10.244.0.0/16

	mkdir -p /home/ubuntu/.kube
	sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
	sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

	# Kubernetes Configuration
	sudo bash -c 'kubeadm token create --print-join-command > /home/ubuntu/join-command.sh'
	gsutil cp /home/ubuntu/join-command.sh gs://bucket-join/join-command.sh
	sleep 10
	sudo -u ubuntu kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

	# Prometheus installation
	sudo helm_install.sh
	kubectl delete configMap prometheus-grafana-kube-pr-pod-total prometheus-grafana-kube-pr-scheduler prometheus-grafana-kube-pr-workload-total prometheus-grafana-kube-pr-namespace-by-pod prometheus-grafana-kube-pr-namespace-by-workload prometheus-grafana-kube-pr-k8s-resources-cluster prometheus-grafana-kube-pr-k8s-resources-multicluster prometheus-grafana-kube-pr-k8s-resources-namespace prometheus-grafana-kube-pr-controller-manager prometheus-grafana-kube-pr-cluster-total prometheus-grafana-kube-pr-etcd prometheus-grafana-kube-pr-grafana-overview prometheus-grafana-kube-pr-nodes-darwin prometheus-grafana-kube-pr-persistentvolumesusage

	# Terraform installation
	# Terraform installation et configuration Apache
	sudo apt-get install -y gnupg software-properties-common python3-pip apache2
	echo "Listen 5001" | sudo tee -a /etc/apache2/ports.conf

	# Configuration du Virtual Host Apache
	sudo tee /etc/apache2/sites-available/redirect.conf >/dev/null <<EOF
<VirtualHost *:5001>
  ProxyPreserveHost On
  ProxyPass / http://127.0.0.1:5000/
  ProxyPassReverse / http://127.0.0.1:5000/
</VirtualHost>
<VirtualHost *:80>
  ProxyPreserveHost On
  ProxyPass / http://127.0.0.1:3001/
  ProxyPassReverse / http://127.0.0.1:3001/
</VirtualHost>
EOF
	sudo a2enmod proxy proxy_http
	sudo a2ensite redirect.conf
	sudo a2dissite 000-default.conf
	sudo systemctl restart apache2
	pip install flask
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
	sudo apt-get install terraform -y
	cd /home/ubuntu/terraform

	echo "Kubernetes Master Initialization Complete" >/var/k8s_init_done

	SLEEP_DURATION=10

	sudo -u ubuntu python3 /home/ubuntu/terraform/auto-scale.py &

	LABEL_KEY="role"
	LABEL_VALUE="worker"

	while true; do
		new_nodes=$(sudo -u ubuntu kubectl get nodes --no-headers | grep -v "${LABEL_KEY}=${LABEL_VALUE}" | awk '{print $1}')

		for node in $new_nodes; do
			sudo -u ubuntu kubectl label nodes $node node-role.kubernetes.io/worker=worker
		done

		sleep $SLEEP_DURATION
	done

} &>/tmp/k8s-master-startup-script.log
