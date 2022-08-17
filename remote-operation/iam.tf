provider "aws" {
    access_key = "AKIAZ6LJEYCNTOR633H7"
    secret_key = "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"
    region = "us-west-2"
}

resource "aws_iam_user" "lb" {
    name = "loadbalancer"
    path = "/system/"
}