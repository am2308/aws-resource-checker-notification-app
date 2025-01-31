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

variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
}