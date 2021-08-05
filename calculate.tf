locals {
  // If a user specifies '.' for dns-name,
  //   we are going to use ${env}.${domain} as the fqdn instead of ${dns-name}.${env}.${domain}
  dns_name_chunk = data.ns_subdomain.this.dns_name == "." ? "" : "${data.ns_subdomain.this.dns_name}."

  // If user specifies var.create_vanity,
  //   we are going to drop ${env} from the fqdn
  env_chunk = var.create_vanity ? "" : "${data.ns_workspace.this.env_name}."

  subdomain_chunk = "${local.dns_name_chunk}${local.env_chunk}"
  subdomain       = trimsuffix(local.subdomain_chunk, ".")
  fqdn            = "${local.subdomain_chunk}${local.domain_name}"

  is_passthrough = local.fqdn == local.domain_name

  // output locals
  name        = !local.is_passthrough ? google_dns_managed_zone.this[0].dns_name : local.domain_name
  zone_id     = !local.is_passthrough ? google_dns_managed_zone.this[0].name : local.domain_zone_id
  nameservers = !local.is_passthrough ? google_dns_managed_zone.this[0].name_servers : local.domain_nameservers
}
