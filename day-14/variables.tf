variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-2"
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name."
  type        = string
  default     = "my-static-website-"
}

