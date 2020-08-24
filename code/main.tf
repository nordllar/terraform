provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "example" {
    ami = "ami-039609244d2810a6b"
    instance_type = "t3.micro"

    tags = {
        Name = "terraform-example"
    }
}