sns_email                = "b110020510@gmail.com"
lambda_name              = "check_temp_resources"
env                      = "test"
eventbridge_name         = "daily_temp_resource_check"
sns_topic_name           = "temp-resource-alerts"
slack_webhook_url        = "https://hooks.slack.com/services/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"
iam_lambda_role_name     = "lambda_execution_role"
aws_cloudwatch_log_group = "/aws/lambda/check_temp_resources"
alert_name               = "lambda_errors"
kms_key_sns              = "alias/aws/sns"