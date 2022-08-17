resource "aws_instance" "myec2" {
  ami = "ami-098e42ae54c764c35"
  instance_type = var.instance_type
}