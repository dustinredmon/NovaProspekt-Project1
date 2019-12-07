/* terraform {
	backend  "s3" {
		region = "us-west-2" 
		bucket = "novaprospekt-bucket"
		key = "terraform.tfstate"
		dynamodb_table = "tf-state-lock"
	}
} */

#Elastic IP for the NAT
resource "aws_eip" "nat" {
	vpc = "true"
}

#NAT Gateway
resource "aws_nat_gateway" "nat-gate" {
	allocation_id = "${aws_eip.nat.id}"
	subnet_id = "${aws_subnet.main-1-public.id}"
	depends_on = ["aws_internet_gateway.main-gate"]
}

#NAT Route tables
resource "aws_route_table" "main-table-private" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.nat-gate.id}"
	}
	tags = {
		Name = "main-table-private"
	}
}

#NAT Route table associations
resource "aws_route_table_association" "main-private-1" {
	subnet_id = "${aws_subnet.server-1-private.id}"
	route_table_id = "${aws_route_table.main-table-private.id}"
}

resource "aws_route_table_association" "main-private-2" {
        subnet_id = "${aws_subnet.server-2-private.id}"
        route_table_id = "${aws_route_table.main-table-private.id}"
} 


