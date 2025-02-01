variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function"
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

variable "slack_webhook_secret_name" {
  description = "Slack webhook URL"
  type        = string
}