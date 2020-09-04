provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  instance_class = "db.t2.micro"
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  name = var.db_name
  username = "admin"

  # How should we set the password?
  password = var.db_password
}

terraform {
  backend "s3" {
    bucket = "terraform-nordllar-state"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-nordllar-locks"
    encrypt = true
  }
}

