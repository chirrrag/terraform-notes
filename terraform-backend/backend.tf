terraform {
  backend "s3" {
    bucket = "rajma-hajma"
    key = "network/tmp.tfstate"
    region = "us-west-2"
    dynamodb_table = "hehehe"
  }
}

resource "time_sleep" "wait_150_seconds" {
  create_duration = "150s"
}