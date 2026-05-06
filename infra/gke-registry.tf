

# --------------------------------------------------
# Enable Required GCP APIs
# --------------------------------------------------
resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])



  project = var.GCP_PROJECT_ID
  service = each.key

  disable_on_destroy = false
}

# --------------------------------------------------
# Artifact Registry (Docker)
# --------------------------------------------------
resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.GCP_PROJECT_ID
  location      = var.region
  repository_id = "smartedx-docker-repo"
  description   = "Docker images for GKE workloads"
  format        = "DOCKER"

  depends_on = [
    google_project_service.services
  ]
}


# --------------------------------------------------
# GKE Cluster (Standard)
# --------------------------------------------------
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  project  = var.GCP_PROJECT_ID

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.GCP_PROJECT_ID}.svc.id.goog"
  }

  depends_on = [

    google_project_service.services
  ]
}
