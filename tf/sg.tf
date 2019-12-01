#AWS security groups
resource "aws_security_group" "bastion-sg" {
  name   = "bastion-sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] #Add your IP address/range for added security
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server-sg" {
  name   = "server-sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  name = "elb-sg"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Public keys 'mypass'
resource "aws_key_pair" "key_pair" {
	key_name = "key_pair"
	public_key = "${file("~/.ssh/keypair.pub")}" #Generate ssh keys with ssh-keygen
	#public_key = "ADD YOUR RSA SSH PUBLIC KEY HERE OR USE FILE REFERENCE ABOVE"
}
