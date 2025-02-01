resource "null_resource" "zip_lambda" {
  triggers = {
    always_run = timestamp() # Ensures this runs on every Terraform apply
  }
  provisioner "local-exec" {
    command = "cd ${path.module} && rm -rf lambda.zip && zip lambda.zip lambda_function.py && mv lambda.zip ../../"
  }
}

resource "aws_lambda_function" "check_temp_resources" {
  function_name = var.lambda_name
  role          = var.lambda_role_arn
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  filename      = "${path.root}/lambda.zip"
  timeout       = 300
  environment {
    variables = {
      SNS_TOPIC_ARN     = var.sns_topic_arn,
      SLACK_SECRET_NAME = var.slack_webhook_secret_name
    }
  }
  tracing_config {
    mode = "Active"
  }
  tags = merge(var.common_tags, {
    Name        = var.lambda_name
    Environment = var.environment
  })
  depends_on = [null_resource.zip_lambda]
}