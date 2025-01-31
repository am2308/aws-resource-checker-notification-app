variable "lambda_arn" {
  description = "Lambda function ARN"
  type        = string
}

variable "eventbridge_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment"
  type        = string
}