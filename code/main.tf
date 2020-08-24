terraform {
  required_version = ">= 0.12, < 0.14"
}
provider "aws" {
    region = "eu-north-1"

    # Allow any 2.x version of AWS provider
}

resource "aws_instance" "example" {
    ami = "ami-039609244d2810a6b"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {

  name = var.security_group_name

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}