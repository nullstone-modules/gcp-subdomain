data "ns_connection" "certificate" {
  name     = "certificate"
  contract = "block/gcp/certificate-manager"
  optional = true
}

locals {
  ext_certificate_id       = try(data.ns_connection.certificate.outputs.certificate_id, "")
  ext_certificate_map_id   = try(data.ns_connection.certificate.outputs.certificate_map_id, "")
  ext_certificate_map_name = try(data.ns_connection.certificate.outputs.certificate_map_name, "")

  create_cert = !var.disable_certificate && local.ext_certificate_map_id == ""
}

// If user specifies "certificate" connection, we use that certificate
// Otherwise, we use var.disable_certificate to determine if we should create a certificate
module "cert" {
  source  = "nullstone-modules/sslcert/gcp"
  version = "~> 0.1.0"

  enabled = local.create_cert
  name    = local.resource_name
  labels  = local.labels
  scope   = ""

  subdomains = {
    (local.subdomain_name) = local.subdomain_zone_id
  }
}

locals {
  certificate_id       = coalesce(local.ext_certificate_id, module.cert.certificate_id)
  certificate_map_id   = coalesce(local.ext_certificate_map_id, module.cert.certificate_map_id)
  certificate_map_name = coalesce(local.ext_certificate_map_name, module.cert.certificate_map_name)
}
