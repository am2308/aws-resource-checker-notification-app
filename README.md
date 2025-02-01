# AWS Temporary Resource Checker Notification App

## Overview
This solution deploys an AWS Lambda function that checks for temporary EC2 instances with the naming prefix `temp-ad-hoc-*` and notifies a configured SNS email & slack.

## Architecture
- **Terraform** provisions the infrastructure.
- **AWS Lambda** runs the script to check EC2 instances.
- **AWS SNS** sends notifications.
- **CloudWatch Events** triggers the Lambda function daily at 6 PM.
- **IAM Policies** restrict Lambda access.
- **Monitoring** via CloudWatch Logs and Alarms.
- **KMS** Encrypt sns topic and cloudwatch log group.

## Prerequisites
- An AWS account
- GitHub repository to store the Terraform code
- OIDC connection for GitHub Actions to assume an IAM role in AWS
- An S3 bucket and DynamoDB table for Terraform backend storage

## Setting Up a New AWS Account for Deployment

### 1. Create an S3 Bucket for Terraform Backend
Terraform requires a remote backend to store its state.

```sh
aws s3 mb s3://notification-app-terraform-backend-bucket --region ap-south-1
```

### 2. Create a DynamoDB Table for State Locking
```sh
aws dynamodb create-table \
    --table-name terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```

### 3. Configure IAM Role for GitHub Actions (OIDC)

#### a. Create an IAM Role for GitHub Actions
```sh
aws iam create-role --role-name GitHubOIDCRole --assume-role-policy-document file://github-oidc-trust.json
```

#### b. Define the Trust Policy (github-oidc-trust.json)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<YOUR_GITHUB_USER>/<YOUR_REPO>:*"
        }
      }
    }
  ]
}
```
Make sure to replace:
<YOUR_ACCOUNT_ID> with your AWS Account ID.
<YOUR_GITHUB_USER>/<YOUR_REPO> with your actual GitHub organization/user and repository.

#### c. Attach Required Policies
```sh
aws iam attach-role-policy --role-name GitHubOIDCRole --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### 4. Store IAM Role ARN in GitHub Secrets
Navigate to **GitHub Repository → Settings → Environments → Create new environment → test → Environment Secrets → New environment secret**, and add:

- **AWS_ROLE_ARN** → The IAM role ARN from step 3.
- **AWS_REGION** → The AWS region (e.g., `ap-south-1`).

## Deployment via GitHub Actions

Once the GitHub Actions workflow is configured, pushing changes to the `main` branch will trigger Terraform to deploy the infrastructure.

### Steps
1. **Push your code to GitHub:**
   ```sh
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```
2. **GitHub Actions Workflow Triggers:**
   - Runs Terraform initialization, validation, and security scans by executing **GitHub Repository → Actions → Terraform CI/CD** workflow.
   - Requires manual approval before deployment.
   - Deploys the infrastructure if approved.

### Monitoring Deployment
- Navigate to **GitHub Repository → Actions** to monitor the Terraform execution.
- Terraform plans will be displayed, and deployment will proceed upon approval.
- AWS CloudWatch Logs will capture Lambda execution details.

## Cleanup via GitHub Actions
To destroy resources, execute workflow **GitHub Repository → Actions → Terraform Destroy CI/CD**:
Then upon approval, the Terraform destroy action will execute.

## Additional Notes
- All AWS interactions should be done via GitHub Actions.
- Local execution of Terraform is not recommended to maintain consistency and security.
- Ensure GitHub OIDC integration is properly configured before deployment.