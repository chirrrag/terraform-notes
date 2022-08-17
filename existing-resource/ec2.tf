resource "aws_instance" "myec2" {
  ami = "ami-0cea098ed2ac54925"
  instance_type = "t2.micro"
  key_name = "terraform-key.pem"
  vpc_security_group_ids = ["sg-0cf57b1ed81f02ea1"]
  tags = {
    "Name" = "terraform-linux"
  }

}