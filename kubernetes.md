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
./k8s-build.sh
./k8s-configure.sh
./k8s-deploy.sh
kubectl rollout history deployment mydeployment
```

## Cleaning up

```bash
kubectl delete -f src/main/kubernetes
minikube stop
```
