# Running the demo app on Kubernetes

You can use this same app to test a couple of Kubernetes features with not much work.

## Installing the Pre-requisites (Mac OSX)

See: https://gist.github.com/kevin-smets/b91a34cea662d0c523968472a81788f7

```bash
brew update && brew install kubectl && brew cask install docker minikube virtualbox
```

## Build, Run and Expose the spring boot app on Minikube...

```bash
./gradlew clean check assemble
minikube start
eval $(minikube docker-env))
docker build -t pcf-springboot-demo:v2 .
kubectl run --restart=Always --image=pcf-springboot-demo:v2 --port=8080 demo
kubectl get pods
kubectl port-forward <pod-name-here> 8080:8080
kubectl expose deployment demo --type=NodePort
curl $(minikube service demo --url)
```

## Cleaning up

```bash
kubectl delete service demo
kubectl delete deployment demo
minikube stop
```
