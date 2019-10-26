#AWS s3 bucket for storage
terraform {
	backend  "s3" {
	region = "us-west-2"
	bucket = "novaprospekt-bucket"
	key = "terraform.tfstate"
	dynamodb_table = "tf-state-lock"    
	}
} 

provider "aws" {
	region = "us-west-2"
}

#AWS VPC Setup
resource "aws_vpc" "main_vpc" {
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	enable_classiclink = "false"

	tags = {
		Name = "main_vpc"
	}
}

#Subnets for service and bastion instances 
resource "aws_subnet" "bastion-1-public" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "us-west-2a"
	tags = {
		Name = "bastion-1-public"
	}
}

resource "aws_subnet" "main-1-public" {
        vpc_id = "${aws_vpc.main_vpc.id}"
        cidr_block = "10.0.2.0/24"
        map_public_ip_on_launch = "true"
        availability_zone = "us-west-2b"
        tags = {
                Name = "main-1-public"
        }
}

resource "aws_subnet" "main-2-public" {
        vpc_id = "${aws_vpc.main_vpc.id}"
        cidr_block = "10.0.3.0/24"
        map_public_ip_on_launch = "true"
        availability_zone = "us-west-2c"
        tags = {
                Name = "main-2-public"
        }
}

resource "aws_subnet" "server-1-private" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	cidr_block = "10.0.4.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = "us-west-2a"
	
	tags = {
		Name = "server-1-private"
	}
}

resource "aws_subnet" "server-2-private" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	cidr_block = "10.0.5.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = "us-west-2b"

	tags = {
		Name = "server-2-private"
	}
}

#NAT Gateway
resource "aws_internet_gateway" "main-natgate" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	tags = {
		Name = "main-natgate"
	}
}

#Route tables
resource "aws_route_table" "main-public" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.main-natgate.id}"
	}
	tags = {
		Name = "main-public"
	}
}

resource "aws_route_table_association" "bastion-1" {
	subnet_id = "${aws_subnet.bastion-1-public.id}"
	route_table_id = "${aws_route_table.main-public.id}"
}
