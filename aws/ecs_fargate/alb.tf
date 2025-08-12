module "alb" {
  source = "../alb"

  app_name             = var.app_name
  app_port             = var.app_port
  app_protocol         = var.app_protocol
  app_protocol_version = var.app_protocol_version
  ca_cert              = var.ca_cert
  certificate_arn      = var.certificate_arn
  enable_mtls          = var.enable_mtls
  public_subnets       = var.public_subnets
  vpc_id               = var.vpc_id
}