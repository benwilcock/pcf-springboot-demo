#!/bin/bash
# Note: you can create Docker registry secrets in a similar way, using the `docker-registry` rather than `generic`. 
# See `kubectl create secret --help` for details.

kubectl delete secret mysecret
kubectl create secret generic mysecret --type=string --from-literal=database.username=admin --from-literal=database.password=password --from-literal=vcap.services="{\"rediscloud\": [{\"binding_name\": \"myrediscloudbinding\",\"credentials\": {\"hostname\": \"myinstance.redislabs.com\",\"password\": \"mypassword\",\"port\": \"12841\"},\"instance_name\": \"redis\",\"label\": \"rediscloud\",\"name\": \"redis\",\"plan\": \"30mb\",\"provider\": null,\"syslog_drain_url\": null,\"volume_mounts\": []}]}"
