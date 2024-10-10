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

	gsutil cp gs://bucket-join/join-command.sh /home/ubuntu/join-command.sh
	sudo bash /home/ubuntu/join-command.sh
} &>/tmp/k8s-worker-startup-script.log
