###########################################
################# Outputs #################
###########################################

output "PublicIPs" {
  value = tonumber(var.instance_count) >= 1 ? " Public IP Adresses are ${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)} " : "Confluent Cloud Platform on AWS is disabled" 
}

output "SSH" {
  value = tonumber(var.instance_count) >= 1 ? " SSH  Access: ssh -i ~/keys/hackathon-temp-key.pem ec2-user@${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)} " : "Confluent Cloud Platform on AWS is disabled" 
}
output "ZOOKEEPER" {
  value = tonumber(var.instance_count) >= 1 ? " --zookeeper ${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:2181" : "Confluent Cloud Platform on AWS is disabled"
}
output "KAFKA" {
  value = tonumber(var.instance_count) >= 1 ? " --bootstrap-Server ${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:9094" : "Confluent Cloud Platform on AWS is disabled"
}  
output "MDS" {
  value = tonumber(var.instance_count) >= 1 ? " confluent login --url  http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:8090" : "Confluent Cloud Platform on AWS is disabled"
}  
output "C3" {
  value = tonumber(var.instance_count) >= 1 ? " Control Center: http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:9021" : "Confluent Cloud Platform on AWS is disabled"
}  
output "CONNECT" {
  value = tonumber(var.instance_count) >= 1 ? " Connect: curl http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:8083" : "Confluent Cloud Platform on AWS is disabled"
}  
output "KSQL" {
  value = tonumber(var.instance_count) >= 1 ? " ksql http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:8088" : "Confluent Cloud Platform on AWS is disabled"
}  
output "SR" {
  value = tonumber(var.instance_count) >= 1 ? " Schema Registry: curl  http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:8081" : "Confluent Cloud Platform on AWS is disabled"
}  
output "REST" {
  value = tonumber(var.instance_count) >= 1 ? " REST Proxy: curl  http://${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)}:8082" : "Confluent Cloud Platform on AWS is disabled"
}  
output "LDAP" {
  value = tonumber(var.instance_count) >= 1 ? " ldapsearch -D \"cn=Hubert J. Farnsworth,ou=people,dc=planetexpress,dc=com\" -w professor -p 389 -h ${join(",",formatlist("%s", aws_instance.rbac-demo.*.public_ip),)} -b \"dc=planetexpress,dc=com\" -s sub \"(objectclass=*)\"" : "Confluent Cloud Platform on AWS is disabled"
}  

