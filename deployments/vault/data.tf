data "google_container_cluster" "this" {
  project = var.project
  name = var.cluster_name
  location = var.region
}

data "google_client_config" "default" {}

data "kubernetes_service_v1" "vault-deployment" {
  metadata {
    name = "vault-ui"
  }
  depends_on = [
    helm_release.vault
  ]
}

// data "kubernetes_service_v1" "dashboard-deployment" {
//   metadata {
//     name = "kubernetes-dashboard"
//   }

//   depends_on = [
//     helm_release.kubernetes-dashboard
//   ]
// }
