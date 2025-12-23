# 0.4.0 (Dec 23, 2025)
* Changed domain delegator to use keyfile or impersonation.

# 0.3.4 (Feb 07, 2025)
* Flatten subdomain if using a wildcard certificate.

# 0.3.3 (Jan 27, 2025)
* Add a random string to the end of the managed zone name so it is always unique.

# 0.3.2 (Dec 19, 2024)
* Added optional `certificate` connection for importing an SSL certificate.

# 0.3.1 (Dec 14, 2024)
* Pull subdomain info from Nullstone instead of calculating.
* Upgrade `ns` terraform provider.

# 0.3.0 (Dec 13, 2024)
* Added SSL certificate and certificate map.
* Added terraform lockfile.

# 0.2.1 (May 10, 2023)
* Enable Cloud DNS GCP API.

# 0.2.0 (Apr 20, 2023)
* Update FQDN to have a trailing '.'.

# 0.1.0 (Aug 05, 2021)
* Initial draft
