module "vpc1" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  azs = ["us-west-2b", "us-west-2c"]
  public_subnet_cidrs =  ["10.0.1.0/24","10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24","10.0.4.0/24"]
  enable_nat_gw_per_az = true
 }
