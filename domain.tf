data "ns_connection" "domain" {
  name     = "domain"
  contract = "domain/gcp/cloud-dns"
}

// We will need to be able to support secondary providers since the root domain
//   is typically managed in a separate account from non-production environments
provider "google" {
  alias                       = "domain"
  project                     = local.delegator_project_id
  credentials                 = local.delegator_impersonate ? null : local.delegator_key_file
  impersonate_service_account = local.delegator_impersonate ? local.delegator_email : null
}

locals {
  domain_dns_name       = data.ns_connection.domain.outputs.name
  domain_fqdn           = data.ns_connection.domain.outputs.fqdn
  domain_zone_id        = data.ns_connection.domain.outputs.zone_id
  domain_nameservers    = data.ns_connection.domain.outputs.nameservers
  delegator             = data.ns_connection.domain.outputs.delegator
  delegator_project_id  = try(local.delegator["project_id"], "missing")
  delegator_impersonate = try(local.delegator["impersonate"], false) == true
  delegator_key_file    = try(base64decode(local.delegator["key_file"]), null)
  delegator_email       = try(local.delegator["email"], null)
}
