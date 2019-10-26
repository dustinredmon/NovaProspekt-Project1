#backend state
/*terraform {
	backend  "s3" {
	region = "us-west-2"
	bucket = "novaprospekt-bucket"
	key = "terraform.tfstate"
	dynamodb_table = "tf-state-lock"    
	}
}*/

#provider
provider "aws" {
  #version = "~> 2.0"
  region  = "us-west-2"
}

#vpc
resource "aws_vpc" "vpc_main" {
	cidr_block = "172.31.0.0/16"
}

#public subnet 1 - 4094 usable hosts
resource "aws_subnet" "sub_1_public" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2a"
  cidr_block = "172.31.0.0/20"

  tags = {
    Name = "Subnet_1_public"
  }
}

#public subnet 2 - 4094 usable hosts
resource "aws_subnet" "sub_2_public" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2b"
  cidr_block = "172.31.16.0/20"

  tags = {
    Name = "Subnet_2_public"
  }
}

#public subnet 3 - 4094 usable hosts
resource "aws_subnet" "sub_3_public" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2c"
  cidr_block = "172.31.32.0/20"

  tags = {
    Name = "Subnet_3_public"
  }
}

#private subnet 1 - 8190 usable hosts
resource "aws_subnet" "sub_1_private" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2a"
  cidr_block = "172.31.64.0/19"

  tags = {
    Name = "Subnet_1_private"
  }
}

#private subnet 2 - 8190 usable hosts
resource "aws_subnet" "sub_2_private" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2b"
  cidr_block = "172.31.96.0/19"

  tags = {
    Name = "Subnet_2_private"
  }
}

#private subnet 3 - 8190 usable hosts
resource "aws_subnet" "sub_3_private" {
  vpc_id     = "${aws_vpc.vpc_main.id}"
  availability_zone = "us-west-2c"
  cidr_block = "172.31.128.0/19"

  tags = {
    Name = "Subnet_3_private"
  }
}

#internet gateway for incoming traffic
/*resource "aws_internet_gateway" "inet_gw" {
  vpc_id = "${aws_vpc.vpc_main.id}"

  tags = {
    Name = "Internet_GW"
  }
}*/

#NAT instance for outgoing traffic
resource "aws_internet_gateway" "NAT" {
  vpc_id = "${aws_vpc.vpc_main.id}"

  tags = {
    Name = "NAT"
  }
}

#route table
resource "aws_route_table" "main_route_tab" {
  vpc_id = "${aws_vpc.vpc_main.id}"

  route {
    cidr_block = "0.0.0.0/0"#possible edit according AWS docs how to set NAT instance (change for NAT instance ID)
    gateway_id = "${aws_internet_gateway.NAT.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = "${aws_internet_gateway.NAT.id}"
  }  
  tags = {
    Name = "main_route_tab_NAT"
  }
}

#subnet assosiation with RT
resource "aws_route_table_association" "assosiation" {
  subnet_id      = "${aws_subnet.sub_1_public.id}"
  route_table_id = "${aws_route_table.main_route_tab.id}"
}

#create NATSG security group (for NAT instance)
resource "aws_security_group" "NATSG" {
  name        = "natsg"
  description = "SG for NAT instance"
  vpc_id      = "${aws_vpc.vpc_main.id}"

#allow inbound HTTP traffic from servers in private subnet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.64.0/19"]#from private subnet1
  }
#allow inbound HTTPS traffic from servers in private subnet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.64.0/19"]#from private subnet1
  }
#allow inbound HTTPS traffic from servers in private subnet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = 
  }


#allow outbound HTTP access to the internet
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    #prefix_list_ids = ["pl-12c4e678"]
  }
#allow outbound HTTPS access to the internet
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    #prefix_list_ids = ["pl-12c4e678"]
  }

}

