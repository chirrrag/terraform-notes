module "ec2" {
  source = "../../modules/ec2"
  instance_type="t2.large"
}

resource "aws_instance" "myec2" {
  ami = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.ec2.sg_id]
}

output "sg" {
  value = module.ec2.sg_id
}