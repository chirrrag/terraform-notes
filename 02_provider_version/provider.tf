terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        # ------------------------------------------------
        # version = "~> 3.0"
        # ------------------------------------------------
        # changingn versin to 2.x range
        # ------------------------------------------------
        # version = "~> 2.0"
        # ------------------------------------------------
        # we have to delete the lock.hcl file to delete the version
        # or use command
        # > terraform init -upgrade
        # changging version by using upgrade flag
        version = ">=2.0, <=3.0"
        # it works, lol xD
        
        
    }
  }
}

provider "aws" {
  region = "us-east-1"
}