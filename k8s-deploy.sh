#!/bin/bash
kubectl delete -f src/main/kubernetes/service.yaml
kubectl delete -f src/main/kubernetes/deployment.yaml
kubectl delete -f src/main/kubernetes/database.yaml
kubectl apply -f src/main/kubernetes/database.yaml
kubectl apply -f src/main/kubernetes/deployment.yaml
kubectl apply -f src/main/kubernetes/service.yaml
