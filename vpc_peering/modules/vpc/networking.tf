resource "aws_vpc" "vpc1" {
    cidr_block = "${var.vpc1_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "vpc1"
    }
}
resource "aws_vpc" "vpc2" {
    cidr_block = "${var.vpc2_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "vpc2"
    }
}

/*
VPC peering
*/

resource "aws_vpc_peering_connection" "Peer" {
  peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id   = "${aws_vpc.vpc1.id}"
  vpc_id        = "${aws_vpc.vpc2.id}"
  
  tags = {
    Name = "VPC Peering between vpc1 and vpc2"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.vpc1.id}"
}
/*
  Public Subnet of Vpc1
*/
resource "aws_subnet" "vpc1_public" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "${var.vpc1_public_subnet_cidrs}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags {
        Name = "vpc1 Public Subnet"
    }
}
resource "aws_route_table" "vpc1_pub_route" {
     
    vpc_id = "${aws_vpc.vpc1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
    tags {
        Name = "vpc1 Public Subnet RT"
    }
}
resource "aws_route_table_association" "vpc1_public_RTA" {
    subnet_id = "${aws_subnet.vpc1_public.id}"
    route_table_id = "${aws_route_table.vpc1_pub_route.id}"
}
/*
  vpc1 Private Subnet
*/
resource "aws_subnet" "vpc1_private_subnet" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "${var.vpc1_private_subnet_cidrs}"
    availability_zone = "us-east-1f"
    tags {
        Name = "vpc1 Private Subnet"
    }
}

resource "aws_route_table" "vpc1_private_RT" {
    vpc_id = "${aws_vpc.vpc1.id}"
    route {         
        cidr_block = "${var.vpc2_private_subnet_cidrs}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.Peer.id}"               
    }
    tags {
        Name = "vpc1 Private Subnet RT"
    }
}

resource "aws_route_table_association" "vpc1_private_RTA" {
    subnet_id      = "${aws_subnet.vpc1_private_subnet.id}"
    route_table_id = "${aws_route_table.vpc1_private_RT.id}"   
}
/*
  vpc2 Private Subnet
*/
resource "aws_subnet" "vpc2_private_subnet" {
    vpc_id = "${aws_vpc.vpc2.id}"
    cidr_block = "${var.vpc2_private_subnet_cidrs}"
    availability_zone = "us-east-1f"
    tags {
        Name = "vpc2 Private Subnet"
    }
}

resource "aws_route_table" "vpc2_private_RT" {
    vpc_id = "${aws_vpc.vpc2.id}"
    route {       
        cidr_block = "${var.vpc1_private_subnet_cidrs}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.Peer.id}"                 
    }
    tags {
        Name = "vpc2 Private Subnet RT"
    }
}

resource "aws_route_table_association" "vpc2_private_RTA" {
    subnet_id      = "${aws_subnet.vpc2_private_subnet.id}"
    route_table_id = "${aws_route_table.vpc2_private_RT.id}"   
}

output "vpc1_id" {
  value = "${aws_vpc.vpc1.id}"
}
output "vpc2_id" {
  value = "${aws_vpc.vpc2.id}"
}
output "vpc1_pub_subnet" {
  value = "${aws_subnet.vpc1_public.id}"
}
output "vpc1_pri_subnet" {
  value = "${aws_subnet.vpc1_private_subnet.id}"
}
output "vpc2_pri_subnet" {
  value = "${aws_subnet.vpc2_private_subnet.id}"
}
output "pub_az" {
  value = "${aws_subnet.vpc1_public.availability_zone}"
}
output "pri_az" {
  value = "${aws_subnet.vpc1_private_subnet.availability_zone}"
}









