#!/bin/bash
yum update -y
yum install wget -y
yum install unzip -y
yum install java-1.8.0-openjdk-devel.x86_64 -y
yum install openldap-clients -y
yum install jq -y
yum install expect -y
yum install nc -y
# install docker
yum install -y docker
# set environment
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -w vm.max_map_count=262144
echo "    *       soft  nofile  65535
    *       hard  nofile  65535" >> /etc/security/limits.conf
sed -i -e 's/1024:4096/65536:65536/g' /etc/sysconfig/docker
# enable docker    
usermod -a -G docker ec2-user
service docker start
chkconfig docker on
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install confluent cli
curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/bin
chown  chown ec2-user:ec2-user /usr/local/bin/confluent
chmod +x /usr/local/bin/confluent

mkdir -p /home/ec2-user/software
chown ec2-user:ec2-user -R /home/ec2-user/software
cd /home/ec2-user/software


# install Confluent Platform
wget ${confluent_platform_location}
tar -xvf confluent-5.4.1-2.12.tar.gz
chown ec2-user:ec2-user -R confluent-5.4.1/*
rm confluent-5.4.1-2.12.tar.gz

export PATH=/bin:/usr/local/bin:/home/ec2-user/software/confluent-5.4.1/bin:\$PATH
export CONFLUENT_HOME=/home/ec2-user/software/confluent-5.4.1

# install RBAC Demo
wget ${confluent_rbac_demo}
unzip master.zip
chown ec2-user:ec2-user -R /home/ec2-user/software/confluent-rbac-hands-on-master/
rm master.zip
chown ec2-user:ec2-user -R confluent-rbac-hands-on-master/*
cd /home/ec2-user/software/confluent-rbac-hands-on-master
rm -r terraform/


# set PUBLIC IP and change the Data in docker-compose.yaml
cd /home/ec2-user/software/confluent-rbac-hands-on-master/rbac-docker
PUBIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
SCRIPT1="sed -i 's/CONNECT_REST_ADVERTISED_HOST_NAME: connect/CONNECT_REST_ADVERTISED_HOST_NAME: $PUBIP/g' docker-compose.yml;"
SCRIPT2="sed -i 's/CONTROL_CENTER_KSQL_KSQL1_ADVERTISED_URL: http:\/\/localhost:8088/CONTROL_CENTER_KSQL_KSQL1_ADVERTISED_URL: http:\/\/$PUBIP:8088/g' docker-compose.yml;"
SCRIPT3="sed -i 's/KAFKA_CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS: http:\/\/localhost:8090/KAFKA_CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS: http:\/\/$PUBIP:8090/g' docker-compose.yml;"
SCRIPT4="sed -i 's/KAFKA_ADVERTISED_LISTENERS: INTERNAL:\/\/localhost:9093,EXTERNAL:\/\/broker:9092,OUTSIDE:\/\/localhost:9094/KAFKA_ADVERTISED_LISTENERS: INTERNAL:\/\/localhost:9093,EXTERNAL:\/\/broker:9092,OUTSIDE:\/\/$PUBIP:9094/g' docker-compose.yml;"
# change docker-compose file with public IP for advertised properties 
bash -c "$SCRIPT1"
bash -c "$SCRIPT2"
bash -c "$SCRIPT3"
bash -c "$SCRIPT4"

# config bash_profile for ec2-user
echo "export PATH=/usr/local/bin:/home/ec2-user/software/confluent-5.4.1/bin:\$PATH
export CONFLUENT_HOME=/home/ec2-user/software/confluent-5.4.1" >> /home/ec2-user/.bash_profile
chown ec2-user:ec2-user /home/ec2-user/.bash_profile
echo "export PATH=/bin:/usr/local/bin:/home/ec2-user/software/confluent-5.4.1/bin:\$PATH
export CONFLUENT_HOME=/home/ec2-user/software/confluent-5.4.1" >> /root/.bashrc

# Start environment
#/home/ec2-user/software/confluent-rbac-hands-on-master/rbac-docker/confluent-start.sh
#chown ec2-user:ec2-user -R conf/
