resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc-1.id}"
}

resource "aws_route_table" "public-crt" {
    vpc_id = "${aws_vpc.vpc-1.id}"
}
resource "aws_eip" "nat_eip" {
  vpc        = "true" 
}
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.subnet-private-1.id}"
}
resource "aws_route_table" "private-crt" {
    vpc_id = "${aws_vpc.vpc-1.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.nat.id}"
    }
}
resource "aws_route_table_association" "crta-public-subnet-1"{
    subnet_id = "${aws_subnet.subnet-public-1.id}"
    route_table_id = "${aws_route_table.public-crt.id}"

}
resource "aws_route_table_association" "crta-private-subnet-1"{
    subnet_id = "${aws_subnet.subnet-private-1.id}"
     route_table_id = "${aws_route_table.private-crt.id}"
}
resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.vpc-1.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

