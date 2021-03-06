#!/usr/bin/env bash
cf create-service p-config-server trial config -c config-server-setup.json
cf create-service cleardb spark mysql
cf create-service cloudamqp lemur rabbit
cf create-service p-service-registry trial registry
cf create-service rediscloud 30mb redis
cf create-service p-circuit-breaker-dashboard trial breaker
