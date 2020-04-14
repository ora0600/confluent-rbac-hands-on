# Running RBAC on docker-compose in Cloud

This docker-compose based setup includes:
- Zookeeper
- OpenLDAP
- Kafka with MDS, connected to the OpenLDAP
- Schema Registry
- KSQL
- Connect
- Rest Proxy
- C3
- install all utilities like jq, docker, expect, wget, unzip, java, ldap-tools

## Prerequisites

see [Prerequisites](https://github.com/ora0600/confluent-rbac-hands-on)

## Getting Started
Before executing terraform for lab-environment deployment, change the [variables.tf](aws/variables.tf) with your aws_access_key and aws_secret_key. As well your own SSK key shoudl be used. see ssh_key_name.
To start confluent platform 5.4.1 including setup for RBC demo in AWS run
```
cd aws
terraform init
terraform plan
terraform apply
```
Terraform will deploy the complete environment, you have to start in manually later.
The output of terraform will show you all the endpoints:
```
terraform output
C3 =  Control Center: http://pubip:9021
CONNECT =  Connect: curl http://pubip:8083
KAFKA =  --bootstrap-Server pubip:9094
KSQL =  ksql http://pubip:8088
LDAP =  ldapsearch -D "cn=Hubert J. Farnsworth" -w professor -p 389 -h pubip -b "dc=planetexpress,dc=com" -s sub "(objectclass=*)"
MDS =  confluent login --url  http://pubip:8090
REST =  REST Proxy: curl  http://pubip:8082
SR =  Schema Registry: curl  http://pubip:8081
SSH =  SSH  Access: ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip 
ZOOKEEPER =  --zookeeper pubip:2181
```
It takes a little till everything is up and running in compute VM. 
Login into cloud compute instance via ssh and start docker-compose:
```bash 
ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip
cd /home/ec2-user/software/confluent-rbac-hands-on-master/rbac-docker
./confluent-start.sh
```
Doing hands-on see [Start-Page](https://github.com/ora0600/confluent-rbac-hands-on#hands-on-agenda-and-labs)

To stop docker-compose setup:
```bash
ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip
docker-compose -p rbac down
```
Destroy the cloud environment:
```bash
terraform destroy
```