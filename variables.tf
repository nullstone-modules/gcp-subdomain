variable "create_vanity" {
  type        = bool
  description = <<EOF
Enable this to create vanity subdomain instead of environmental.
This is typically enabled on the production environment.
If dns-name is set to '.' and create_vanity is enabled, this will module act as a passthrough; outputs from the connected domain are used for outputs.
EOF
  default     = false
}

variable "disable_certificate" {
  type        = bool
  default     = false
  description = "Specify true to disable SSL certificate creation"
}

variable "skip_delegation" {
  type        = bool
  default     = false
  description = <<EOF
Enable skip_delegation to prevent creating a GCP DNS zone dedicated to this subdomain.
This is useful when two subdomains in Nullstone collide (e.g. `a.b.domain.com` and `b.domain.com`).
By enabling, all subsequent DNS records are stored in the root domain DNS zone `domain.com`.
EOF
}
