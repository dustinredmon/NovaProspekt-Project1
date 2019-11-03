resource "aws_elb" "np-elb" {
  name = "np-elb"
  subnets = ["${aws_subnet.main-1-public.id}", "${aws_subnet.main-2-public.id}"]
  security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_acm_certificate_validation.default.certificate_arn}"
  }
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }
  
  instances = ["${aws_instance.server-1.id}", "${aws_instance.server-2.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
  tags = {
    Name = "my-elb"
  }
}
