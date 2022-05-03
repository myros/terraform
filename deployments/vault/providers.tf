
provider "google" {
  region  = var.region
  project = var.project_id
}

terraform {
  backend "gcs" {
    bucket  = "maginfo-tf-backend"
    prefix  = "cloud"
 
    // encryption_key = "xOJ22WdqRNsVssRxxtnKSGoPka6auCyfWiob1KQfs1k="
  }
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

