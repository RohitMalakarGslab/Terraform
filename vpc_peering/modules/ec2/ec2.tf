

resource "aws_instance" "Ec2_vpc1_public" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.public_subnet_id}"
  availability_zone = "${var.pub_azs}"
  associate_public_ip_address = true
  key_name = "vpc1_test"
  tags = {
    Name = "Ec2_vpc1_public"
  }
}
resource "aws_instance" "Ec2_vpc1_private" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.private_subnet_id}"
  availability_zone = "${var.pri_azs}"
  key_name = "vpc1_test"
    tags = {
    Name = "Ec2_vpc1_private"
  }
}
resource "aws_instance" "Ec2_vpc2_private" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.vpc2_private_sub}"
  availability_zone = "${var.pri_azs}"
  key_name = "vpc1_test"
    tags = {
    Name = "Ec2_vpc2_private"
  }
}

