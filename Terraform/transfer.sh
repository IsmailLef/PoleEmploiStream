#!/bin/bash

SSH_KEY="./ssh/id_rsa"

REMOTE_HOST=$1

REMOTE_USER="ubuntu"

DEST_FOLDER="/home/ubuntu"

SCP_COMMAND="scp -o StrictHostKeyChecking=no -i $SSH_KEY -r"

#Update ip for autoscaling :
cp ../Prometheus/values.yaml ../Prometheus/values.yaml.bak
sed -i "s/<AUTOSCALER_IP>/$REMOTE_HOST/g" ../Prometheus/values.yaml

$SCP_COMMAND ../StreamnProcess ../script.sh ../Kube-config/ ../Prometheus/ $REMOTE_USER@$REMOTE_HOST:$DEST_FOLDER
$SCP_COMMAND ./ssh ./config.tf ./network.tf ./firewall.tf ./cluster-vars.tf ./workers.tf ./bucket_setup.sh ./k8s-master-startup-script.sh ./k8s-worker-startup-script.sh ./sdtd-402113-de780093b26b.json ./auto-scale.py $REMOTE_USER@$REMOTE_HOST:$DEST_FOLDER/terraform

mv ../Prometheus/values.yaml.bak ../Prometheus/values.yaml

echo "Transfert terminé"
