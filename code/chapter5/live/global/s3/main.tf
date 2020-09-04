terraform {
  required_version = ">= 0.12, <0.13"
}

provider "aws" {
  region = "us-east-2"
  version = "~> 2.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-nordllar-state"

  # Prevent accidental deletion of S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name = "terraform-nordllar-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-nordllar-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-nordllar-locks"
    encrypt = true
  }
}
