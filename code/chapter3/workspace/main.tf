terraform {
  required_version = ">= 0.12, <0.13"
}

provider "aws" {
  region = "us-east-2"
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket = "terraform-nordllar-state"
    key = "workspaces-example/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-nordllar-locks"
    encrypt = true
  }
}

resource "aws_instance" "exapmle" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

