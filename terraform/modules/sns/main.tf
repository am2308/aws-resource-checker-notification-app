resource "aws_sns_topic" "notification_topic" {
  name = var.sns_topic_name
  tags = merge(var.common_tags, {
    Name        = var.sns_topic_name
    Environment = var.environment
  })
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

# Slack Subscription via HTTPS Webhook
resource "aws_sns_topic_subscription" "slack_target" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "https"
  endpoint  = var.slack_webhook_url
}