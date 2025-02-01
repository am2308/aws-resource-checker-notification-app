variable "aws_cloudwatch_log_group" {
  description = "The name of the CloudWatch log group to create"
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

variable "alert_name" {
  description = "Name of the alert"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
}

variable "kms_key" {
  description = "KMS key"
}