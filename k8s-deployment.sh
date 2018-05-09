#!/bin/bash
kubectl delete -f src/main/kubernetes
kubectl create -f src/main/kubernetes
# kubectl port-forward rs/myreplicaset 8080:8080
