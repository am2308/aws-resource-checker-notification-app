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
  kms_key_sns    = var.kms_key_sns
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
