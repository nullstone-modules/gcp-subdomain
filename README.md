# gcp-subdomain

Nullstone module to create a subdomain on GCP.

## Overview

This module creates a DNS Zone on Google Cloud DNS.

By default, this module will create an SSL certificate using GCP Certificate Manager.
This can be disabled by setting the variable `disable_certificate = true`.
This certificate is created for Cloud CDNs and Load Balancing (most common use case).
A certificate and certificate map are created and emitted as outputs for use to attach to a GCP Load Balancer.

## Subdomain Calculation

This module adds the current Nullstone environment into the FQDN for the resulting subdomain.

#### Example
  Domain:     `acme.com`
  Env:        `dev`
  `dns_name`: `api`
  FQDN:       `api.dev.acme.com`

If `var.create_vanity = true`, then the environment chunk is omitted from the FQDN.
In the above example, the FQDN becomes: `api.acme.com`.
Typically, enabling this variable is done to create a production URL.
