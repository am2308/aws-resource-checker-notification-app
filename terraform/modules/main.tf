resource "aws_kms_key" "this" {
  description             = "Customer Managed KMS Key for CloudWatch Logs & SNS"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "EnableRootAccountAccess",
        Effect    = "Allow",
        Principal = { "AWS" : "arn:aws:iam::${var.aws_account_id}:root" },
        Action    = "kms:*",
        Resource  = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsEncryption",
        Effect = "Allow",
        Principal = {
          Service = "logs.${var.region}.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowSNSEncryption",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
  tags = merge(var.common_tags, {
    Name        = var.alias
    Environment = var.environment
  })
}