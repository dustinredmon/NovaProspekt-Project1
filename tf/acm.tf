provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias = "acm"
  region = "us-east-1"
}

resource "aws_acm_certificate" "default" {
  provider = "aws.acm"
  domain_name = "novaprospekt.xyz"
  validation_method = "DNS"
}

data "aws_route53_zone" "external" {
  name = "novaprospekt.xyz"
}

resource "aws_route53_record" "validation" {
  name    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "default" {
  provider = "aws.acm"
  certificate_arn = "${aws_acm_certificate.default.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
  ]
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  aliases = ["novaprospekt.xyz"]
  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate_validation.default.certificate_arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}

