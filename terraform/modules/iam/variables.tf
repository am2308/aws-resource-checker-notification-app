variable "iam_lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_cloudwatch_log_group" {
  description = "AWS CloudWatch log group name"
  type        = string
}

variable "slack_webhook_secret_name" {
  description = "Slack webhook URL"
  type        = string
}