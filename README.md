# Terraform with NAT gateway 
Task: create a vpc with 2 public and 2 private subnet and NAT gateway based on "enable_nat_gw_per_az" value.

Based on number of availability zone it will create NAT gateway on each public subnet if "enable_nat_gw_per_az" is true otherwise only NAT will be created on any of public subnet and both the private subnet will be allocated to that NAT gateway

# Vpc Peering using terraform
 
Task: Create two vpc, vpc1 with two subnet (1 public and 1 private), vpc2 with 1 private subnet. Access the vpc2 private subnet ec2 from vpc1 private subnet ec2 using vpc peering.

note: there is no code writter for sequrity group and key pair.Kindly create a key and mention the name of the key in Ec2 module ec2 code.
also create and attache a sequrity group (with ssh)to generated Ec2 instances to test vpc peering.
