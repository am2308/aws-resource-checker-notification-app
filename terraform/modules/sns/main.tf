// This Terraform configuration file defines resources for creating an AWS SNS topic and an email subscription to that topic.

// The `aws_sns_topic` resource block creates an SNS topic with the specified name and KMS master key for encryption.
// The `name` attribute sets the name of the SNS topic using the value from the `sns_topic_name` variable.
// The `kms_master_key_id` attribute sets the KMS key for encrypting the SNS topic using the value from the `kms_key` variable.
// The `tags` attribute adds tags to the SNS topic, merging common tags from the `common_tags` variable with additional tags for the name and environment.

// The `aws_sns_topic_subscription` resource block creates an email subscription to the SNS topic.
// The `topic_arn` attribute specifies the ARN of the SNS topic to subscribe to, using the ARN of the `notification_topic` resource.
// The `protocol` attribute sets the protocol for the subscription to "email".
// The `endpoint` attribute sets the email address to receive notifications, using the value from the `sns_email` variable.

resource "aws_sns_topic" "notification_topic" {
  name              = var.sns_topic_name
  kms_master_key_id = var.kms_key
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