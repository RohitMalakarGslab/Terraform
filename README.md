# Terraform with NAT gateway 
Task: create a vpc with 2 public and 2 private subnet and NAT gateway based on "enable_nat_gw_per_az" value.

Based on number of availability zone it will create NAT gateway on each public subnet if "enable_nat_gw_per_az" is true otherwise only NAT will be created on any of public subnet and both the private subnet will be allocated to that NAT gateway
