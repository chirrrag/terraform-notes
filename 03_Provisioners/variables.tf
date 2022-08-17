variable "access_key" {
  default = "AKIAZ6LJEYCNTOR633H7"
}

variable "secret_key" {
  default = "kcatwqSVFdeKzxJ/XbVu9GfRQ1knCDcounW1n3rA"
}

variable "region" {
  default = "us-west-2"
}
# variable "instance_type" {
# #   default = "t2.medium"
# }

variable "elb_name" {
  type = string
}
variable "az" {
  type = list(any)
}
variable "timeout" {
  type = number
}