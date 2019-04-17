module "vpc" {
  source = "./modules/vpc"
  vpc1_cidr = "10.100.0.0/16"
  vpc2_cidr = "10.200.0.0/16"
  vpc1_public_subnet_cidrs =  "10.100.0.0/24"
  vpc1_private_subnet_cidrs = "10.100.1.0/24"
  vpc2_private_subnet_cidrs = "10.200.1.0/24"
  peer_owner_id = "add your AWS accont ID"
   #azs = ["us-west-2b", "us-west-2c"]
 }

 /*
  Creating ec2 instances on us_east virginia region 
*/
 module "ec2" {
   source = "./modules/ec2"
   ami = "ami-0080e4c5bc078760e"
   instance_type = "t2.micro"
   public_subnet_id = "${module.vpc.vpc1_pub_subnet}"
   private_subnet_id = "${module.vpc.vpc1_pri_subnet}"
   vpc2_private_sub = "${module.vpc.vpc2_pri_subnet}"
   pub_azs = "${module.vpc.pub_az}"
   pri_azs = "${module.vpc.pri_az}"
 }

