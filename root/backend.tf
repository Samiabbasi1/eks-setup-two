terraform {
  required_version = "~> 1.9.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.62.0"
    }
  }
  backend "s3" {
    bucket = "remote-backend"
    region = "us-east-1"
    key = "newbackend/terraformnew.tfstate"
    encrypt = true
  }
}