resource "aws_security_group" "bastion-sg" {
  name   = "bastion-sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
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
	public_key = "${file("keypair.pub")}"
	#public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4zXrJ9dujryYeFEFDItKAlTDIO0RNgjA8k8lNEWLm7u1vMLs6tUxBHGTrDcmAKyYygxxdWbo79p69nnX2Q/QDPxts/bZrzEpcEMm1ylWvRVinf72qKTb526or7SrlrQ9zXsayPL0wKYlOUhkKjddeELzvb7dL416qOAraCs/wpyCoz9jrCe46LtfUKA7KSlO5a3TV/88UFKvYTxv/E5MGR2vUXEg2r9HjUKMkD2GN/gdlw/GY/wvGBl1J8dj3+luEstgMxeUA7462kRRAJJ8kngt6b6Jlp1dX7PoBv1SMB1b8KcNeIJ8Y8JbTxKbRrD7QZIY6sNtb0CKKNmGqfoMldUXzegs9I5jwFTxuBJ/jiL2WE/dhrAERXzY9KGE1aFfOQqaNq/ZkVsiyTw8ofEC2r/VX7b9IfGPMdUbSuZNk7294ZyO6+gT0PLsvJAbCpFmQE/JMu9E8D2ygZSbu1ZjWJzXpQx8r5nppZ/wv8p3pAO31d8xwPaAbwtDzPbgG742txSNi1Y/EcCLqfEKObML3QkZSIJq6r5/OJOvInSSLYKQCTgL7mhnpncfsx54qmBgLe6kVoVwedMOVWnMi9385CGUjAB4/lwh7zxesT04dKj1Vt1U15D68YCVj9wF233GNNiNH+tU5T3dsnDwOm9fh90BJDCPXJb1PgVeUbbOdIw== shtyrtsvlad@gmail.com"
}
