# AWS Config

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}

variable "ssh_key_name" {
}

variable "instance_type_resource" {
  default = "t2.large"
  # running compute with 2 vCPUs and 8GB RAM should be enough for a demo
}
variable "confluentrbacdemo" {
  default = "https://github.com/ora0600/confluent-rbac-hands-on/archive/master.zip"
}

variable "confluent_platform_location" {
  default = "http://packages.confluent.io/archive/5.4/confluent-5.4.1-2.12.tar.gz"
}

variable "confluent_home_value" {
  default = "/home/ec2-user/software"
}

variable "instance_count" {
    default = "1"
  }
