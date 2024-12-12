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

variable "certificate_purpose" {
  type        = string
  default     = "load-balancer"
  description = <<EOF
This enables creating a GCP-managed SSL certificate in Certificate Manager.
The purpose allows you to configure the certificate for the device
Available choices: "cdn" for Cloud CDN, "load-balancer" for Internet Load Balancers, or "internal"
EOF

  validation {
    condition     = contains(["cdn", "load-balancer", "internal"], var.certificate_purpose)
    error_message = <<EOF
The purpose must be one of 'cdn', 'load-balancer', or 'internal'.
This is meant to create a certificate that is specific to the ingress device that it is attached.
EOF
  }
}
