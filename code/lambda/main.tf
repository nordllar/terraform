resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = "poppler_test"
  filename = "poppler.zip"
  description = "Poppler layer to be used in lambda function ParseDocument"

  compatible_runtimes = ["python 3.7"]
}