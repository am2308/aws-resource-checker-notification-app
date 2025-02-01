## Standard account specific variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "test"
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    Project    = "DataPlatformMonitoring"
    Owner      = "Data Engineering Team"
    CostCenter = "12345"
    Department = "Engineering"
    ManagedBy  = "Terraform"
    CreatedBy  = "GitHub Actions"
  }
}

## IAM module specific variables
variable "iam_lambda_role_name" {
  description = "IAM Role name for Lambda"
  type        = string
  default     = "lambda_execution_role"
}

## SNS module specific variables

variable "sns_email" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "b110020510@gmail.com"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "temp-resource-alerts"
}

#variable "slack_webhook_url" {
#  description = "Slack webhook URL"
#  type        = string
#  default     = ""
#}

## Lambda module specific variables

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "check_temp_resources"
}

## Monitoring module specific variables
variable "aws_cloudwatch_log_group" {
  description = "CloudWatch log group for Lambda"
  type        = string
  default     = "/aws/lambda/check_temp_resources"
}

variable "alert_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
  default     = "lambda_errors"
}

## EventBridge module specific variables

variable "eventbridge_name" {
  description = "Name of the EventBridge rule"
  type        = string
  default     = "daily_temp_resource_check"
}

variable "kms_key_sns" {
  description = "KMS key for SNS"
  type        = string
  default     = "alias/aws/sns"
}

variable "slack_webhook_secret_name" {
  description = "Slack webhook URL"
  type        = string
  default     = ""
}