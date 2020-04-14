# Confluent Platform 5.4 Role-Based Access Control (RBAC) Hands-on Workshop

Role based access control (RBAC) was introduced in Confluent Platform version 5.3 as a preview feature. With Confluent Platform 5.4 RBAC is now production ready.

This github project describes a Hands-on Workshop around Confluent RBAC. The structure of the Hands-on is as followed
* Explaining and Introduce Role based Access Control
* Labs: Get to know the environment
* Advanced explanation of Role based Access Control
* Advanced RBAC Labs to setup the real use case

In general, the hands-on will take 4 hours.
* Start at   10am: Intro and first labs
* break at   12am: 1 hour break
* Continue at 1pm: Additional Labs
* Finish at   3pm

# Environment for Hands-on Workshop Labs
The Hands-on environment can be deployed in three ways 
1. run Docker-Compose on your own hardware/laptop [use docker-locally](rbac-docker/)
2. create the demo environment in Cloud Provider infrastructure, [deploy cloud environment](terraform/)
3. Confluent will deploy a cloud environment for you, and will send you during the workshop all credentials

## Prerequisites for running environment in Cloud
For an environment in cloud you need to run following components on your machine: 
* Browser with internet access
* if you want to deploy in our own environment
  - create your own SSH key and deploy in AWS/Google, I use the key name `hackathon-temp-key`
  - terraform have to be installed
  - Terraform will install everything you need to execute during the workshop on cloud compute instance
* Having internet access and Port 80, 443, 22, 9021 have to be open

## Prerequisites for running environment on own hardware
For an environment on your hardware, you have to 
- Docker installed
- Java8 installed
- Confluent Platform 5.4 installed: set environment variables
  ```bash  
  export CONFLUENT_HOME=YOURPATH
  export PATH=$CONFLUENT_HOME/bin:$PATH
  ```
- Confluent cli installed
```bash
curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/bin
chmod +x /usr/local/bin/confluent
# add into PATH if not there
export PATH=$PATH:/usr/local/bin/
```

## Optional
Install on your desktop Apache Directory Studio to create and modify LDAP users in openLDAP. [Download Apache Directory Studio](https://directory.apache.org/studio/downloads.html)
Apache Directory Studio is important if you want to add user/group in openLDAP or modify users or groups.
We offer also the possibility to add user via ldapadd on the command line prompt. So, Apache Directory is really optinal.

# Hands-on Workshop
Three days before the workshop we will send out to all attendees an email:
* Please be prepare
  * Watch Video Replay of RBAC as foundation for this Hands-on Workshop, see [here](https://events.confluent.io/kitchentour2020)
  * Your HW/SW have to be prepared before the workshop starts
* And we will ask you, if you would like to run on your own environment or you would like to have an environment provisioned by Confluent in the cloud.

## Hands-on Agenda and Labs:
0. We will start with a first environment check:
   * Attendees with an environment provisioned by Confluent should all have an email with credentials etc.
   * Is everything up and running: local, cloud or environment give by confluent.
   * We expect a 20 MIN time-slot for this exercise
1. Intro Role based Access Control (PPT)              -   30 Min
   * RECAP Role based Access Control - short presentation by presenter (10 minutes)
   * What is the structure for today? (20 minutes)
2. LAB 1-2: Understand the environment and first labs -   60 Min                                               
   * Short intro and demo by presenter (10 Min)
   * Attendes doing Labs (50 Min)
     * Lab1: Start-up RBAC and Check your environment
       - on your local machine, [Check your environment](labs/Lab1-localmachine.md/)
       - in cloud environment, [Check your environment](labs/Lab1-cloud.md)
     * Lab 2: Get started with the environment
       - on your local machine, [goto Lab2-localmachine](labs/Lab2-localmachine.md)
       - in cloud , [goto to Lab2-cloud](labs/Lab2-cloud.md)
3. LUNCH Break                                         -     60 Minutes
4. Lab 3-4: Advanced RBAC setup                        -    110 Minutes         
   * Short Introduction and demo by presenter (20 Min)
   * Attendess doing their labs (90 Min)
   * Lab 3. First Authorization check: Execute check authorization lab: [Lab3](labs/Lab3.md)
   * Lab 4. Advanced RBAC Lab, setup real use case: [Lab4](labs/Lab4.md)
5. Wrap-up and Finish                                 -     15 Minutes

# Stop everything
Note: By Confluent provisioned Compute VMS will be destroyed at 5pm latest on Workshop day automatically.
Outside of cloud compute, please use terraform, to really destroy the environment in the cloud:
```bash
terraform destroy
```
If you inside cloud compute you can stop the environment;
```bash
cd /home/ec2-user/software/confluent-rbac-hands-on-master/rbac-docker
docker-compose -p rbac down
```
A restart inside the compute:
```bash
./confluent_start.sh
```
On your local machine just execute
```bash
cd confluent-rbac-hands-on-master/rbac-docker
docker-compose -p rbac down
```

Thanks a lot for attending
Confluent Team.
