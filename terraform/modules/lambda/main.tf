// This Terraform configuration file defines resources for deploying an AWS Lambda function
// and ensuring that the Lambda deployment package is created and updated on every apply.

// Resource: null_resource.zip_lambda
// This resource ensures that the Lambda deployment package (lambda.zip) is created and updated
// on every Terraform apply. It uses a local-exec provisioner to execute shell commands.
// - triggers: Forces the resource to run on every apply by using the current timestamp.
// - provisioner "local-exec": Executes shell commands to create the Lambda deployment package.
//   - command: Changes directory to the module path, removes any existing lambda.zip file,
//     creates a new lambda.zip file containing lambda_function.py, and moves the zip file
//     to the parent directory.

// Resource: aws_lambda_function.check_temp_resources
// This resource defines an AWS Lambda function with the specified configuration.
// - function_name: The name of the Lambda function, provided by the variable var.lambda_name.
// - role: The ARN of the IAM role that the Lambda function assumes, provided by the variable var.lambda_role_arn.
// - runtime: The runtime environment for the Lambda function (Python 3.9).
// - handler: The function handler in the Lambda function code (lambda_function.lambda_handler).
// - filename: The path to the Lambda deployment package (lambda.zip) created by the null_resource.zip_lambda.
// - timeout: The maximum time (in seconds) that the Lambda function can run (300 seconds).
// - environment: Environment variables for the Lambda function.
//   - SNS_TOPIC_ARN: The ARN of the SNS topic, provided by the variable var.sns_topic_arn.
//   - SLACK_SECRET_NAME: The name of the Slack webhook secret, provided by the variable var.slack_webhook_secret_name.
// - tracing_config: Enables AWS X-Ray tracing for the Lambda function.
//   - mode: The tracing mode (Active).
// - tags: Tags to apply to the Lambda function, merging common tags with specific tags.
//   - Name: The name of the Lambda function, provided by the variable var.lambda_name.
//   - Environment: The environment name, provided by the variable var.environment.
// - depends_on: Ensures that the Lambda function is created only after the null_resource.zip_lambda has run.


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