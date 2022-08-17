# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
  access_key = "AKIAZ6LJEYCNTOR633H7"
  secret_key = "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"
}

resource "aws_instance" "my-ec2" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
