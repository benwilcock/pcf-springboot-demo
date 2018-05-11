#!/bin/bash
# Note: you can create Docker registry secrets in a similar way, using the `docker-registry` rather than `generic`. 
# See `kubectl create secret --help` for details.
kubectl delete configmap myconfigmap
kubectl delete secret mysecret
kubectl create -f src/main/kubernetes/configmap.yaml
kubectl create secret generic mysecret --type=string --from-literal=database.username=test --from-literal=database.name=test --from-literal=database.password=test --from-literal=vcap.services="{\"mysql\": [ {  \"binding_name\": null,  \"credentials\": {   \"hostname\": \"mysql.svc.default.cluster\",   \"jdbcUrl\": \"jdbc:mysql://mysql.default.svc.cluster.local/test?user=test\u0026password=test\",   \"name\": \"test\",   \"password\": \"test\",   \"port\": \"3306\",   \"uri\": \"mysql://test:test@mysql.default.svc.cluster.local:3306/test?reconnect=true\",   \"username\": \"test\"  },  \"instance_name\": \"mysql\",  \"name\": \"mysql\",  \"plan\": \"myplan\",  \"provider\": null,  \"syslog_drain_url\": null,  \"tags\": [   \"Cloud Databases\"  ],  \"volume_mounts\": [] }]}"