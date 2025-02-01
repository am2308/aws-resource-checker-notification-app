#!/bin/bash

# Create main Terraform directory
mkdir -p terraform/{modules/lambda,modules/eventbridge,modules/sns,modules/iam,modules/monitoring,modules/kms,vars/test}

# Create root-level Terraform files
touch terraform/{main.tf,variables.tf,outputs.tf,providers.tf,terraform.tf}

# Create backend configuration file for different environments
touch terraform/vars/test/test.backend.tfvars

# Create variables files for different environments
touch terraform/vars/test/test.tfvars

# Create module Terraform files
for module in lambda eventbridge sns iam monitoring kms; do
  touch terraform/modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Create a placeholder Lambda function file
echo -e "import json\n\ndef lambda_handler(event, context):\n    return {'statusCode': 200, 'body': json.dumps('Hello from Lambda!')}" > terraform/modules/lambda/lambda_function.py

echo "Terraform modular structure created successfully!"
