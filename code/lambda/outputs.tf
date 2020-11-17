output "lambda_layer_arn_name" {
  value = [aws_lambda_layer_version.poppler_layer.arn, aws_lambda_layer_version.parseMe_layer.arn]
}