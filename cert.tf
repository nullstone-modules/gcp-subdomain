module "cert" {
  source  = "nullstone-modules/sslcert/gcp"
  version = "~> 0.1.0"

  enabled = !var.disable_certificate
  name    = local.resource_name
  labels  = local.labels
  scope   = ""

  subdomains = {
    (local.subdomain_name) = local.subdomain_zone_id
  }
}

locals {
  certificate_id       = module.cert.certificate_id
  certificate_map_id   = module.cert.certificate_map_id
  certificate_map_name = module.cert.certificate_map_name
}
