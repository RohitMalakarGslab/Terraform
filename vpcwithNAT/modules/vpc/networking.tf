resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}
resource "aws_eip" "nat" {
        #count = "${length(var.public_subnet_cidrs)}"
        count = "${var.enable_nat_gw_per_az ? length(var.azs) : 1}"
        vpc = true
        tags {
            Name = "EIP${count.index + 1}"
        }
}
/*
  NAT gateway
*/

resource "aws_nat_gateway" "defaultNAT" { 
    count = "${var.enable_nat_gw_per_az ? length(var.azs) : 1}"
    subnet_id = "${aws_subnet.public.*.id[count.index]}"
    allocation_id = "${aws_eip.nat.*.id[count.index]}"
  tags = {
    Name = "gw NAT_${count.index + 1}"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "public" {
    count = "${length(var.public_subnet_cidrs)}"
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet_cidrs[count.index]}"
    map_public_ip_on_launch = true
    availability_zone = "${var.azs[count.index]}"

    tags {
        Name = "Public Subnet_${count.index +1}"
    }
}
resource "aws_route_table" "public" {
     
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}
resource "aws_route_table_association" "public" {
    count = "${length(var.public_subnet_cidrs)}"
    subnet_id = "${aws_subnet.public.*.id[count.index]}"
    route_table_id = "${aws_route_table.public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "private" {
    count= "${length(var.private_subnet_cidrs)}"
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet_cidrs[count.index]}"
    availability_zone = "${var.azs[count.index]}"
    tags {
        Name = "Private Subnet_${count.index +1}"
    }
}

resource "aws_route_table" "private" {
    count = "${var.enable_nat_gw_per_az ? length(var.azs) : 1}"
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.defaultNAT.*.id[count.index]}"
        
    }
    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "private" {
    count= "${length(var.private_subnet_cidrs)}"
    #subnet_id = "${aws_subnet.private.*.id[count.index]}"
    
    #route_table_id = "${aws_route_table.private.count > 1 ? aws_route_table.private.*.id[count.index] : aws_route_table.private.id}"
    subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}
