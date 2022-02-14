

# enabling needed services
resource "google_project_service" "enabled_services" {
  for_each = toset(var.project_services)
  project  = var.project_id
  service  = each.key

  provisioner "local-exec" {
    command = "sleep 10"
  }

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

// resource "google_project_service" "service" {
//   count   = length(var.project_services)
//   project = var.project_id
//   service = element(var.project_services, count.index)

//   # Do not disable the service on destroy. On destroy, we are going to
//   # destroy the project, but we need the APIs available to destroy the
//   # underlying resources.
//   disable_on_destroy = false
// }


#
# EXTERNAL IP RESERVATION
# ------------------------------------
// resource "google_compute_address" "static" {
//   project       = var.project_id
//   region        = var.region
//   name = "ipv4-address"
// }

// resource "google_compute_address" "internal" {
//   name         = "my-internal-address"
//   address_type = "INTERNAL"
//   purpose      = "GCE_ENDPOINT"
//   project       = var.project_id
//   region        = var.region
// }
// module "address" {
//   source       = "terraform-google-modules/address/google"
//   version      = "3.0.0"
//   project_id   = var.project_id # Replace this with your service project ID in quotes
//   region       = var.region
//   address_type = "EXTERNAL"
//   names  = [ "external-facing-ip"]
//   global = true
// }

// output "ip" {
//   value = google_compute_address.internal.address
// }
// output "ip1" {
//   value = google_compute_address.static.address
// }

#
# SERVICE ACCOUNTS
# ------------------------------------

// gcloud iam service-accounts create vault-server \
//     --display-name "vault service account"
resource "google_service_account" "vault_sa" {
  account_id   = "vault-sa-${random_string.this.result}"
  display_name = "HashiCorp Vault Service Account"
  project      = var.project_id
}

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.vault_sa.name
  // keepers = {
  //   rotation_time = time_rotating.mykey_rotation.rotation_rfc3339
  // }
}

// resource "null_resource" "update-kubectl" {
//   count = 1 // "${var.init_cli ? 1 : 0 }"

//   triggers = {
//     cluster = "${data.google_container_cluster.this.id}"
//   }

//   # On creation, we want to setup the kubectl credentials. The easiest way
//   # to do this is to shell out to gcloud.
//   provisioner "local-exec" {
//     command = "gcloud container clusters get-credentials --region=${var.region} ${data.google_container_cluster.this.name}"
//   }

//   # On destroy we want to try to clean up the kubectl credentials. This
//   # might fail if the credentials are already cleaned up or something so we
//   # want this to continue on failure. Generally, this works just fine since
//   # it only operates on local data.
//   // provisioner "local-exec" {
//   //   when       = "destroy"
//   //   on_failure = "continue"
//   //   command    = "kubectl config get-clusters | grep ${data.google_container_cluster.this.name} | xargs -n1 kubectl config delete-cluster"
//   // }

//   // provisioner "local-exec" {
//   //   when       = "destroy"
//   //   on_failure = "continue"
//   //   command    = "kubectl config get-contexts | grep ${data.google_container_cluster.cluster.name} | xargs -n1 kubectl config delete-context"
//   // }
// }
