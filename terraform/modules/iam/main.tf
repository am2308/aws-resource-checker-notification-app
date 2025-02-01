// This Terraform configuration file defines IAM resources for a Lambda function.
// It includes the following resources:
// 1. aws_iam_role "lambda_exec": Defines an IAM role for Lambda execution with an assume role policy.
// 2. aws_iam_policy "lambda_permissions": Defines an IAM policy granting necessary permissions for the Lambda function.
// 3. aws_iam_role_policy_attachment "lambda_permissions_attachment": Attaches the IAM policy to the IAM role.

// The IAM role "lambda_exec" is configured with:
// - A name specified by the variable `iam_lambda_role_name`.
// - Tags that include common tags and environment-specific tags.
// - An assume role policy that allows Lambda service to assume this role.

// The IAM policy "lambda_permissions" grants the following permissions:
// - Create and manage CloudWatch log groups and streams, and put log events.
// - Describe EC2 instances.
// - Publish messages to an SNS topic.
// - Retrieve secret values from AWS Secrets Manager.
// - Decrypt and generate data keys using AWS KMS.

// The IAM role policy attachment "lambda_permissions_attachment" attaches the "lambda_permissions" policy to the "lambda_exec" role.


resource "aws_iam_role" "lambda_exec" {
  name = var.iam_lambda_role_name
  tags = merge(var.common_tags, {
    Name        = var.iam_lambda_role_name
    Environment = var.environment
  })

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_permissions" {
  name        = "lambda_permissions_policy"
  description = "IAM policy for Lambda to check EC2 instances and log events"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${var.aws_cloudwatch_log_group}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:${var.region}:${var.aws_account_id}:${var.sns_topic_name}"
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:${var.region}:${var.aws_account_id}:secret:${var.slack_webhook_secret_name}-p8bd7k"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": "arn:aws:kms:${var.region}:${var.aws_account_id}:key/${var.kms_key_id}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_permissions_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_permissions.arn
}
