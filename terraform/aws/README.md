# Running RBAC on docker-compose in AWS

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
To start confluent platform 5.4.1 including setup for RBC demo in AWS run
```bash
cd terraform/aws
# edit first env-vars.sample
cp env-vars.sample env-vars
# set your entries into env-vars file
vi env-vars # set your own values
   export TF_VAR_aws_access_key=XXXXXX
   export TF_VAR_aws_secret_key=YYYYYY
   export TF_VAR_aws_region=<ENTER YOUR region>
   export TF_VAR_ssh_key_name=<Enter your sh key name>
   export TF_VAR_instance_count=1
# save 
# source it
source env-vars
# execute terraform
terraform init
terraform plan
terraform apply
```
Terraform will deploy the complete environment and start all service via docker-compose.
The output of terraform will show you all the endpoints:
```bash
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

Doing hands-on see [Start-Page](https://github.com/ora0600/confluent-rbac-hands-on#hands-on-agenda-and-labs)

To stop docker-compose setup:
```
terraform destroy
```