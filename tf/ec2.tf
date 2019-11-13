#EC2 instances
#Bastion instance
resource "aws_instance" "bastion" {
	ami = "ami-06d51e91cea0dac8d"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.key_pair.key_name}"
	subnet_id = "${aws_subnet.bastion-1-public.id}"
	vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
	tags = {
		Name = "bastion_1"
	}
}

#Private server instances
resource "aws_instance" "server-1" {
	ami = "ami-06d51e91cea0dac8d"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.key_pair.key_name}"
	subnet_id = "${aws_subnet.server-1-private.id}"
	vpc_security_group_ids = ["${aws_security_group.server-sg.id}"]
	tags = {
		Name = "server_1"
	}
}

resource "aws_instance" "server-2" {
	ami = "ami-06d51e91cea0dac8d"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.key_pair.key_name}"
	subnet_id = "${aws_subnet.server-2-private.id}"
	vpc_security_group_ids = ["${aws_security_group.server-sg.id}"]
	tags = {
		Name = "server_2"
	}
}
