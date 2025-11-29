terraform {
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
resource "aws_s3_bucket" "day-3-bucket" {
  bucket = "day-3-tf-s3-bucket" # unique name for s3 bucket

  tags = {
    Name        = "day-3-demo-bucket"
    Environment = "Dev"
  }
}