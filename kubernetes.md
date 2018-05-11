# Running the demo app on Kubernetes (Minikube)

You can use this same SpringBoot Demo app to test a couple of Kubernetes features without much work.

## Installing the Kubernetes Pre-requisites (with brew on Mac OSX)

See: https://gist.github.com/kevin-smets/b91a34cea662d0c523968472a81788f7

```bash
brew update && brew install kubectl && brew cask install docker minikube virtualbox
```

### Start Minikube & configure Docker

```bash
minikube start
eval $(minikube docker-env)
```

## Build, Run and Expose the SpringBoot Demo app

```bash
./k8s-build.sh
./k8s-configure.sh
./k8s-deploy.sh
./k8s-watch.sh
```

## Perform an application rollout in Kubernetes

To perform an upgrade (or downgrade) based on the strategy and settings in your `deployment.yaml` follow these steps...

1. Build a new Docker image for the new app version by editing the `build.gradle` file.
1. Change the `src/main/kubernetes/deployment.yaml` kubernetes manifest to match your new image name (and add a reson for the history).
1. Apply the change in kubernetes using `kubectl` as shown below... 

```bash
./k8s-build.sh
kubectl apply -f src/main/kubernetes/deployment.yaml
kubectl rollout history deployment mydeployment
```

If you go with the defaults I've set, Kubernetes will perform a blue/green deployment of your new version, checking for health as it goes.

## Interacting with a running Pod in Kubernetes

```bash
kubectl exec -it <pod-name-here> -- /bin/bash
```

or to run individual commands...

```bash
kubectl exec <pod-name-here> env
kubectl exec <pod-name-here> ps aux
kubectl exec <pod-name-here> ls /
kubectl exec <pod-name-here> cat /proc/1/mounts
```

See: [here](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

## Cleaning up

```bash
kubectl delete -f src/main/kubernetes
minikube stop
```

## Connecting to your MySQL Database

This next bit assumes you have the `mysql` client installed locally (you can get it from `brew` if you don't).

```bash
mysql --host=$(minikube ip) --port=<DATABASE-PORT> -u test -p
SHOW DATABASES;
USE test;
CREATE TABLE example ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );
````
