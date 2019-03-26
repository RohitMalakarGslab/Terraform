variable "vpc_cidr" {
}
variable "public_subnet_cidrs" {
    default = ["10.0.1.0/24","10.0.2.0/24"]
    }

variable "private_subnet_cidrs" {
   default = ["10.0.3.0/24","10.0.4.0/24"]
}
variable "enable_nat_gw_per_az" {
    
}
variable "azs" {
    type = "list"
  
}
variable "mappubip" {
    default = true
  
}






