resource "aws_cloudwatch_event_rule" "daily_check" {
  name                = var.eventbridge_name
  schedule_expression = "cron(0 18 * * ? *)"
  tags = merge(var.common_tags, {
    Name        = var.lambda_name
    Environment = var.environment
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_check.name
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_check.arn
}
