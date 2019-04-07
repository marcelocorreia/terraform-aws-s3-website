provider "aws" {
  region = "ap-southeast-2"
}

module "s3www" {
  source              = "../"
  hostname            = "rnd.badwolf.correia.ninja"
  upload_sample_htmls = true
  zone_name           = "correia.ninja"
  allowed_ips_cidr = ["${var.allowed_ips_cidr}"]
  logs_prefix = "rnd/"
  dns_ttl = "60"
}
variable "allowed_ips_cidr" {
  type = "list"
}

