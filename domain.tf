data "ns_connection" "domain" {
  name     = "domain"
  contract = "domain/gcp/cloud-dns"
}

// We will need to be able to support secondary providers since the root domain
//   is typically managed in a separate account from non-production environments
provider "google" {
  alias       = "domain"
  credentials = local.delegator_key_file
  project     = local.delegator_project_id
}

locals {
  domain_dns_name      = data.ns_connection.domain.outputs.name
  domain_fqdn          = data.ns_connection.domain.outputs.fqdn
  domain_zone_id       = data.ns_connection.domain.outputs.zone_id
  domain_nameservers   = data.ns_connection.domain.outputs.nameservers
  delegator_key_file   = base64decode(data.ns_connection.domain.outputs.delegator["key_file"])
  delegator_project_id = lookup(jsondecode(local.delegator_key_file), "project_id")
}
