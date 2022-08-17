resource "aws_eip" "lb" {
  vpc = true
}

resource "aws_eip" "lb2" {
    provider = "aws.mumbai"
  vpc = true
  profile = "account02"
#   to generate eip in account 2
}