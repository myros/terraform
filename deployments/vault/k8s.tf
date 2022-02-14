locals {
  vault_tls_name = "vault-tls-${random_id.kms_random.hex}"
}

resource "kubernetes_secret" "vault-tls" {
  metadata {
    name = local.vault_tls_name
  }

  data = {
    "vault.crt" = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault-ca.cert_pem}"
    "vault.key" = tls_private_key.vault.private_key_pem
    "ca.crt"    = tls_self_signed_cert.vault-ca.cert_pem
  }
}

resource "kubernetes_secret" "kms-creds" {
  metadata {
    name      = "kms-creds"
    namespace = "default"
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.this.private_key)
  }

  type = "Opaque"
}