#!/bin/bash
watch -n 1 kubectl get pv,pvc,pods,rs,deployments,svc,configmaps,secrets
