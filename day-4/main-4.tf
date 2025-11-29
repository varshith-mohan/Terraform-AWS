terraform {
  backend "s3" {
    bucket       = "day-4-tf-s3-bucket-backend"
    key          = "dev/terraform.tfstate" # terraform.tfstate file in dev folder
    region       = "ap-south-2"
    use_lockfile = true # locking beacuse to prevent state file from corrupting in multi user envirenment
    encrypt      = true # encrypting the state file
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

# create aws s3 bucket
resource "aws_s3_bucket" "day-4-bucket" {
  bucket = "day-4-tf-s3-bucket-test" # unique name for s3 bucket

  tags = {
    Name        = "day-4-demo-bucket"
    Environment = "Dev"
  }
}