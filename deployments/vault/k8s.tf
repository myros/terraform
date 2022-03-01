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

resource "kubernetes_secret" "vault-tls" {
  metadata {
    name = local.vault_tls_name
    namespace = "vault"
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