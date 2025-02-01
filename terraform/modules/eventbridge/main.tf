/*
  This Terraform configuration file sets up an AWS CloudWatch Event Rule, Event Target, and Lambda Permission.

  Resources:
  1. aws_cloudwatch_event_rule.daily_check:
     - Creates a CloudWatch Event Rule named as specified by the variable `eventbridge_name`.
     - The rule triggers on a daily schedule at 18:00 UTC, as defined by the cron expression "cron(0 18 * * ? *)".
     - Tags are assigned to the rule, combining common tags from `var.common_tags` with specific tags for Name and Environment.

  2. aws_cloudwatch_event_target.lambda_target:
     - Defines a target for the CloudWatch Event Rule created above.
     - The target is an AWS Lambda function, specified by the variable `lambda_arn`.

  3. aws_lambda_permission.allow_cloudwatch:
     - Grants CloudWatch Events permission to invoke the specified Lambda function.
     - The permission allows the action `lambda:InvokeFunction` on the Lambda function identified by `var.lambda_arn`.
     - The permission is granted to the principal `events.amazonaws.com`, and is scoped to the source ARN of the CloudWatch Event Rule.
*/

resource "aws_cloudwatch_event_rule" "daily_check" {
  name                = var.eventbridge_name
  schedule_expression = "cron(0 18 * * ? *)"
  tags = merge(var.common_tags, {
    Name        = var.eventbridge_name
    Environment = var.environment
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.daily_check.name
  arn  = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_check.arn
}
