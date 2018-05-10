#!/bin/bash
kubectl delete -f src/main/kubernetes/deployment.yaml
kubectl create -f src/main/kubernetes/deployment.yaml
# kubectl port-forward rs/myreplicaset 8080:8080
