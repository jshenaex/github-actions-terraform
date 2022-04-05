terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
  backend "s3" {
    bucket = "jshen-tf-state-bucket-test"
    key = "path/to/key"
    region = "us-east-2"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

