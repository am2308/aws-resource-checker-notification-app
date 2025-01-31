terraform {
  backend "s3" {
    bucket         = "notification-app-terraform-backend-bucket"
    key            = "tech-lead/homework/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}