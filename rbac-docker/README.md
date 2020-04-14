# Running RBAC in docker-compose on your own machine

This docker-compose based setup includes:
- Zookeeper
- OpenLDAP
- Kafka with MDS, connected to the OpenLDAP
- Schema Registry
- KSQL
- Connect
- Rest Proxy
- C3

## Prerequisites
see [Prerequisites](https://github.com/ora0600/confluent-rbac-hands-on)

## Image Versions
We will use `PREFIX=confluentinc` and `TAG=5.4.1` for all images running via docker-compose. If you want to run newr docker images from Confluent, please change the `docker-compose.yml` file.

## Getting Started
Start the demo environment on your local machine
```
git clone https://github.com/ora0600/confluent-rbac-hands-on.git
./confluent-start.sh
```
Doing hands-on see [Start-Page](https://github.com/ora0600/confluent-rbac-hands-on#hands-on-agenda-and-labs)

To stop docker-compose setup:
```
docker-compose -p rbac down
```