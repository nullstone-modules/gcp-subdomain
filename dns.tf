resource "google_project_service" "dns" {
  service                    = "dns.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_dns_managed_zone" "this" {
  name     = local.resource_name
  dns_name = local.fqdn
  labels   = local.labels
  count    = !local.is_passthrough ? 1 : 0

  depends_on = [google_project_service.dns]
}

resource "google_dns_record_set" "this-delegation" {
  provider = google.domain

  managed_zone = local.domain_zone_id
  name         = local.fqdn
  rrdatas      = google_dns_managed_zone.this[count.index].name_servers
  type         = "NS"
  ttl          = 300

  count = !local.is_passthrough ? 1 : 0
}
