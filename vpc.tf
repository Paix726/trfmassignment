resource "aws_vpc" "vpc-1" {
    cidr_block = "172.19.0.0/16"
    enable_dns_support = "true" 
    enable_dns_hostnames = "true" 
    enable_classiclink = "false"
    instance_tenancy = "default"    
}
   
resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.vpc-1.id}"
    cidr_block = "172.19.0.0/24"
    map_public_ip_on_launch = "true" 
    availability_zone = "ap-southeast-1a"
}

resource "aws_subnet" "subnet-private-1" {
    vpc_id = "${aws_vpc.vpc-1.id}"
    cidr_block = "172.19.1.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "ap-southeast-1b"
}

