# can use this
# https://github.com/anshulpatel25/terraform-private-tls-cert
# Generate self-signed TLS certificates. Unlike @kelseyhightower's original
# demo, this does not use cfssl and uses Terraform's internals instead.
resource "tls_private_key" "vault-ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "vault-ca" {
  key_algorithm   = tls_private_key.vault-ca.algorithm
  private_key_pem = tls_private_key.vault-ca.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "digital_signature",
    "key_encipherment",
    "server_auth"
  ]

  # provisioner "local-exec" {
  #   command = "echo '${self.cert_pem}' > ../tls/ca.pem && chmod 0600 ../tls/ca.pem"
  # }
}

# Create the Vault server certificates
resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Create the request to sign the cert with our CA
resource "tls_cert_request" "vault" {
  key_algorithm   = tls_private_key.vault.algorithm
  private_key_pem = tls_private_key.vault.private_key_pem

  dns_names = [
    "vault",
    "vault.local",
    "vault.default.svc.cluster.local",
    "*.vault-internal",
    "*.vault-internal.vault",
    "vault.default.svc",
    "vault.vault.svc",
    "*.${var.vault_release_name}-internal.vault",
    "${var.vault_release_name}.vault.svc",
    "${var.vault_release_name}.vault",
    //  data.google_compute_address.internal.address
  ]

  ip_addresses = [
    data.google_container_cluster.this.endpoint,
    "34.138.255.102"
  ]

  subject {
    common_name  = "vault.local"
    organization = "HashiCorp Vault"
  }
}

# Now sign the cert
resource "tls_locally_signed_cert" "vault" {
  cert_request_pem = tls_cert_request.vault.cert_request_pem

  ca_key_algorithm   = tls_private_key.vault-ca.algorithm
  ca_private_key_pem = tls_private_key.vault-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.vault-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "client_auth",
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

  # provisioner "local-exec" {
  #   command = "echo '${self.cert_pem}' > ../tls/vault.pem && echo '${tls_self_signed_cert.vault-ca.cert_pem}' >> ../tls/vault.pem && chmod 0600 ../tls/vault.pem"
  # }
}

