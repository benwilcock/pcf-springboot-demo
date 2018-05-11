#!/bin/bash
eval $(minikube docker-env)
export SPRING_PROFILES_ACTIVE=k8s
./gradlew clean build docker