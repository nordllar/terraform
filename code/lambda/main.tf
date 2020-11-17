<<<<<<< Updated upstream
resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = "poppler_test"
  filename = "poppler.zip"
=======
terraform {
  #required_version = ">= 0.12, < 0.13"
}


provider "aws" {
  region = "eu-north-1"

  # Allow any 2.x version of AWS provider
  version = "~> 2.0"
}

#provider "archive" {}

data "archive_file" "zip" {
  type = "zip"
  source_dir = "../../../hydro-dam-safety/lambdas/parse_document"
  output_path = "parseMe.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Lambda layers
resource "aws_lambda_layer_version" "poppler_layer" {
  layer_name = "poppler"
  filename = "../../../../package.zip"
>>>>>>> Stashed changes
  description = "Poppler layer to be used in lambda function ParseDocument"

  compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_layer_version" "parseMe_layer" {
  layer_name = "parseMe"
  filename = "../../../../layers.zip"
  description = "Layer with extra packages to be used in lambda function ParseDocument"

  compatible_runtimes = ["python3.6"]
}

# Lambda function parseDocument renamed parseMe
resource "aws_lambda_function" "example_function" {
  function_name = "parseMe"

  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  handler = "main.lambda_handler"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "python3.6"
  memory_size = 2048
  timeout = 300
  layers = [aws_lambda_layer_version.poppler_layer.arn, aws_lambda_layer_version.parseMe_layer.arn]

  environment {
    variables = {
      TIKA_CLIENT_ONLY = true
      TIKA_SERVER_ENDPOINT = "http://xx.xxx.xx.xx:8080" # Pick up url.
    }
  }
}
