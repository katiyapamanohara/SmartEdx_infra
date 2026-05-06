variable "GCP_PROJECT_ID" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}


variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "eco-gke-cluster"
}

#cloudflare 

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS / Tunnel / Access permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID (domain)"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "domain" {
  description = "Domain name for Cloudflare resources"
  type        = string
}

variable "domain_2" {
  description = "Second domain name for Cloudflare resources"
  type        = string
}

variable "cloudflare_zone_id_2" {
  description = "Cloudflare Zone ID (second domain)"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "postgres_user" {
  description = "PostgreSQL superuser username"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL superuser password"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "Default PostgreSQL database name"
  type        = string
}

variable "minio_root_user" {
  description = "MinIO root user (access key)"
  type        = string
  sensitive   = true
}

variable "minio_root_password" {
  description = "MinIO root password (secret key, min 8 chars)"
  type        = string
  sensitive   = true
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges (CIDR notation) allowed to access restricted domains"
  type        = list(string)
  default     = ["172.206.224.87", "20.121.43.208", "48.216.243.107", "34.82.54.66"]
}

