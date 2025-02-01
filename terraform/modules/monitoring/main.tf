/*
 * This Terraform configuration file defines resources for monitoring AWS Lambda functions.
 * 
 * Resources:
 * 1. aws_cloudwatch_log_group.lambda_log_group:
 *    - Creates a CloudWatch Log Group for Lambda function logs.
 * 2. aws_cloudwatch_metric_alarm.lambda_errors:
 *    - Creates a CloudWatch Metric Alarm for monitoring Lambda function errors.
 */


resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = var.aws_cloudwatch_log_group
  retention_in_days = 30
  kms_key_id        = var.kms_key
  tags = merge(var.common_tags, {
    Name        = var.aws_cloudwatch_log_group
    Environment = var.environment
  })
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = var.alert_name
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    FunctionName = "check_temp_resources"
  }
  alarm_actions = [var.sns_topic_arn]
}
