locals {
  purpose_to_scopes = {
    "cdn" : "EDGE_CACHE"
    "load-balancer" : "ALL_REGIONS"
    "internal" : "DEFAULT"
  }
}

module "cert" {
  source = "nullstone-modules/sslcert/gcp"

  enabled = !var.disable_certificate
  name    = local.resource_name
  labels  = local.labels
  scope   = local.purpose_to_scopes[var.certificate_purpose]

  subdomains = {
    (local.name) = local.zone_id
  }
}

locals {
  certificate_id     = module.cert.certificate_id
  certificate_map_id = module.cert.certificate_map_id
}
