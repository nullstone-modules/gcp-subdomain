terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "domain" {
  name = "domain"
  type = "domain/gcp"
}

// We will need to be able to support secondary providers since the root domain
//   is typically managed in a separate account from non-production environments
provider "google" {
  credentials = data.ns_connection.domain.outputs.delegator["key_file"]

  alias = "domain"
}

locals {
  domain_name    = data.ns_connection.domain.outputs.name
  domain_zone_id = data.ns_connection.domain.outputs.zone_id
}
