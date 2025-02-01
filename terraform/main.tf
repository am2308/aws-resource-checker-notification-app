/*
 * This Terraform configuration file sets up various AWS resources and modules for a notification application.
 * 
 * Modules:
 * - lambda: Configures an AWS Lambda function with necessary parameters such as name, SNS topic ARN, IAM role ARN, environment variables, and common tags.
 * - eventbridge: Configures an AWS EventBridge rule to trigger the Lambda function, with parameters for the EventBridge name, Lambda ARN, environment variables, and common tags.
 * - sns: Configures an AWS SNS topic with parameters for the topic name, email subscription, environment variables, common tags, and KMS key for encryption.
 * - iam: Configures IAM roles and policies for the Lambda function, with parameters for the role name, AWS region, account ID, CloudWatch log group, environment variables, common tags, SNS topic name, Slack webhook secret name, and KMS key ID.
 * - monitoring: Sets up CloudWatch monitoring and alerts, with parameters for the log group, environment variables, common tags, alert name, SNS topic ARN, and KMS key.
 * - kms: Configures an AWS KMS key for encryption, with parameters for the environment variables, common tags, AWS account ID, alias, and region.
 * 
 * Data Sources:
 * - aws_caller_identity: Retrieves information about the current AWS account, such as the account ID.
 */

data "aws_caller_identity" "current" {}

module "lambda" {
  source                    = "./modules/lambda"
  lambda_name               = var.lambda_name
  sns_topic_arn             = module.sns.sns_topic_arn
  lambda_role_arn           = module.iam.lambda_role_arn
  environment               = var.env
  slack_webhook_secret_name = var.slack_webhook_secret_name
  common_tags               = var.common_tags
}

module "eventbridge" {
  source           = "./modules/eventbridge"
  eventbridge_name = var.eventbridge_name
  lambda_arn       = module.lambda.lambda_arn
  common_tags      = var.common_tags
  environment      = var.env
}

module "sns" {
  source         = "./modules/sns"
  sns_topic_name = var.sns_topic_name
  sns_email      = var.sns_email
  common_tags    = var.common_tags
  environment    = var.env
  kms_key        = module.kms.kms_key_arn
}

module "iam" {
  source                    = "./modules/iam"
  iam_lambda_role_name      = var.iam_lambda_role_name
  region                    = var.aws_region
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_cloudwatch_log_group  = var.aws_cloudwatch_log_group
  environment               = var.env
  common_tags               = var.common_tags
  sns_topic_name            = var.sns_topic_name
  slack_webhook_secret_name = var.slack_webhook_secret_name
  kms_key_id                = module.kms.kms_key_id
}

module "monitoring" {
  source                   = "./modules/monitoring"
  aws_cloudwatch_log_group = var.aws_cloudwatch_log_group
  environment              = var.env
  common_tags              = var.common_tags
  alert_name               = var.alert_name
  sns_topic_arn            = module.sns.sns_topic_arn
  kms_key                  = module.kms.kms_key_arn
}

module "kms" {
  source         = "./modules/kms"
  environment    = var.env
  common_tags    = var.common_tags
  aws_account_id = data.aws_caller_identity.current.account_id
  alias          = var.alias
  region         = var.aws_region
}
