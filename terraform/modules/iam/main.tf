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
      "Resource": "arn:aws:secretsmanager:${var.region}:${var.aws_account_id}:secret:$(var.slack_webhook_secret_name)"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_permissions_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_permissions.arn
}
