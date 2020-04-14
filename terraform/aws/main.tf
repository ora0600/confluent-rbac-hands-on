resource "aws_security_group" "sec-rbac-demo" {
  name        = "SecGroupConfluentRBACDemo"
  description = "Security Group for Confluent RBAC Demo Confluent Platform setup"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # OpenLDAP Access Access
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Kafka broker Access
  ingress {
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Zookeeper Access
  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # MDS Access
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # C3 Access
  ingress {
    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Connect Access
  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # KSQL Access
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Schema Registry Access
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # REST Proxy Access
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "rbac-demo" {
  ami           = "${data.aws_ami.ami.id}"
  count         = var.instance_count
  instance_type = var.instance_type_resource
  key_name      = var.ssh_key_name
  vpc_security_group_ids = ["${aws_security_group.sec-rbac-demo.id}"]
  user_data = data.template_file.confluent_instance.rendered

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  tags = {
    "Name" = "Confluent RBAC Demo",
    "Owner" = "cmutzlitz@confluent.io"
  }
}