locals {
  vault_tls_name = "vault-tls"
}

#
# EXTERNAL IP RESERVATION
# ------------------------------------
data "google_compute_address" "external" {
  project       = var.project_id
  region        = var.region
  name = "nginx-ip-address"
}

locals {
  namespaces = ["default", "vault", "banzai-webhook", "vault-injector", "external-secrets"]
}

resource "kubernetes_secret" "vault-tls" {
  count = length(local.namespaces)
  metadata {
    name = local.vault_tls_name
    namespace = element(concat(local.namespaces, [""]), count.index)
  }

  data = {
    "vault.crt" = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault-ca.cert_pem}"
    "vault.key" = tls_private_key.vault.private_key_pem
    "ca.crt"    = tls_self_signed_cert.vault-ca.cert_pem
  }

  depends_on = [
    kubernetes_namespace.vault
  ]

}

resource "kubernetes_secret" "kms-creds" {
  metadata {
    name      = "kms-pl-creds"
    namespace = "vault"
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.this.private_key)
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace.vault
  ]
}


// resource "kubernetes_service_account_v1" "app-1-sa" {
//   metadata {
//     name = "app-1-sa"
//   }

  
//   // secret {
//   //   name = "${kubernetes_secret_v1.example.metadata.0.name}"
//   // }
// }

// data "kubernetes_secret" "app-1" {
// //  depends_on = ${kubernetes_service_account.vault_auth}
//  metadata {
//   name = "${kubernetes_service_account_v1.app-1-sa.default_secret_name}"
//  }
// }

// resource "kubernetes_service_account_v1" "app-2-sa" {
//   metadata {
//     name = "app-2-sa"
//   }
//   // secret {
//   //   name = "${kubernetes_secret_v1.sa-app-1.metadata.0.name}"
//   // }
// }
// resource "kubernetes_service_account_v1" "app-3-sa" {
//   metadata {
//     name = "app-3-sa"
//     namespace = "app-3"
//   }

//   depends_on = [
//     // kubernetes_namespace.app-3
//   ]
// }

