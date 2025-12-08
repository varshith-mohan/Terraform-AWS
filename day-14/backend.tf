terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-gvm"
    key    = "lessons/day14/terraform.tfstate"
    region = "ap-south-2"
  }
}
