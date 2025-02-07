data "ns_subdomain" "this" {
  stack_id = data.ns_workspace.this.stack_id
  block_id = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  // If we detect that the certificate is a wildcard (e.g. `*.acme.com`), we need to flatten our subdomains
  // This is because an SSL cert on `*.acme.com` will not work for `a.b.acme.com`
  // To flatten our subdomain, we're going to replace all `.` with `-` in the `subdomain_name` (i.e. the subdomain fqdn without the domain suffix)
  // This detection only works when using an external certificate with `ns_connection.certificate`
  needs_flattened = anytrue([for domain in local.ext_certificate_domains : strcontains(domain, "*")])
  // Normally, we rely on ns_subdomain to construct the fqdn
  // However, if we're flattening, we need to manually construct it
  // It should look like this: replace(subdomain_name, ".", "-") + "." + domain_name + "."
  flattened_fqdn = "${replace(data.ns_subdomain.this.subdomain_name, ".", "-")}.${data.ns_subdomain.this.domain_name}."
  fqdn           = local.needs_flattened ? local.flattened_fqdn : data.ns_subdomain.this.fqdn
  is_passthrough = data.ns_subdomain.this.subdomain_name == ""

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
