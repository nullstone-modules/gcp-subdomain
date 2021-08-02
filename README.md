# gcp-subdomain

Nullstone module to create a subdomain on GCP.

## Overview

This module creates a DNS Zone which follows a contract to administer through Nullstone.
This module automatically works with [gcp-domain](github.com/nullstone-modules/gcp-domain).

## Connections

- `domain (type=domain/gcp)`
    - Example: [gcp-domain](github.com/nullstone-modules/gcp-domain)

## Variables

(The nullstone block contains the subdomain name.)

- `create_vanity: bool (default: false)` - Enable this to create a vanity subdomain instead of environmental. This is typically enabled on the production environment.

## Outputs

- `name: string` - The name of the created subdomain
- `fqdn: string` - The FQDN (fully-qualified domain name) for the created subdomain
- `zone_id: string` - Google DNS Managed Zone ID
- `nameservers: list(string)` - List of Nameservers for Google DNS Managed Zone
- `domain_name: string` - The name of the root domain
- `domain_zone_id: string` - THe zone ID of the root domain
