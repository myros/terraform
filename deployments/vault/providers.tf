
# provider "google" {
#   region  = var.region
#   project = var.project_id
# }

# provider "google-beta" {
#   region  = var.region
#   project = var.project_id
# }

terraform {
  backend "gcs" {
    bucket  = "myros-tf-backend"
    prefix  = "myprefix"
 
    // encryption_key = "xOJ22WdqRNsVssRxxtnKSGoPka6auCyfWiob1KQfs1k="
  }
  
  required_providers {
    // aws = {
    // }
    // random = {
    // }
  }

  // required_version = "0.12.31"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.this.endpoint}"
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  experiments {
    manifest = true
  }
  kubernetes {
    host = data.google_container_cluster.this.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      data.google_container_cluster.this.master_auth[0].cluster_ca_certificate,
    )
  }
} 

