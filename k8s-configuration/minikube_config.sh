#!/bin/bash

minikube start

# Configurations
kubectl apply -f ./mongo-configmap.yaml
kubectl apply -f ./mongo-secret.yaml

# Services
kubectl apply -f ./mongo-express.yaml
kubectl apply -f ./mongo.yaml
