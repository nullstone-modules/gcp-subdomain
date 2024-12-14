data "ns_subdomain" "this" {
  stack_id = data.ns_workspace.this.stack_id
  block_id = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  fqdn           = data.ns_subdomain.this.fqdn
  is_passthrough = local.fqdn == local.domain_fqdn

  // created_zone_id refers to google_dns_managed_zone.this.name; however, we need this variable to wait on the resource to be created
  // We're going to take google_dns_managed_zone.this.id and parse out the name (since id is computed during creation)
  // Format: projects/{{project}}/managedZones/{{name}}
  created_zone_id     = try(regex("^projects/[^/]+/managedZones/([^/]+)$", google_dns_managed_zone.this[0].id)[0], "")
  created_name        = try(trimsuffix(google_dns_managed_zone.this[0].dns_name, "."), "")
  created_nameservers = [for ns in try(google_dns_managed_zone.this[0].name_servers, []) : trimsuffix(ns, ".")]

  subdomain_name        = local.is_passthrough ? local.domain_dns_name : local.created_name
  subdomain_zone_id     = local.is_passthrough ? local.domain_zone_id : local.created_zone_id
  subdomain_nameservers = local.is_passthrough ? local.domain_nameservers : local.created_nameservers
}
