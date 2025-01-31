output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}

output "lambda_role_arn" {
  value = module.iam.lambda_role_arn
}