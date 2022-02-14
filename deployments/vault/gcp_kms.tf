

locals {
  kms_key_ring = var.kms_key_ring != "" ? var.kms_key_ring : random_id.kms_random.hex
}


# https://console.cloud.google.com/security/kms/keyrings?project=unified-sensor-327013
// resource "google_kms_key_ring" "vault" {
//   name     = local.kms_key_ring
//   location = var.region
//   project  = var.project_id

//   depends_on = [google_project_service.service]
// }

# key ring details
// gcloud kms keys create vault-init \
    // --location us-east1 \
    // --keyring vault \
    // --purpose encryption
// resource "google_kms_crypto_key" "vault-init" {
//   name            = var.kms_crypto_key
//   key_ring        = data.google_kms_key_ring.vault.id
//   rotation_period = "604800s"

//   // lifecycle {
//   //   prevent_destroy = true
//   // } 
// }

data "google_kms_key_ring" "vault" {
  name     = var.kms_key_ring
  project = var.project_id
  location = var.region

  // lifecycle {
  //   prevent_destroy = true
  // } 
}

data "google_kms_crypto_key" "vault-init" {
  name     = var.kms_crypto_key
  key_ring = data.google_kms_key_ring.vault.id
}

# Non-authoritative. Updates the IAM policy to grant a role to a new member. Other members for the role for the crypto key are preserved.
resource "google_kms_crypto_key_iam_member" "vault-init" {
  crypto_key_id = data.google_kms_crypto_key.vault-init.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.vault_sa.email}"
}

resource "google_kms_key_ring_iam_binding" "key_ring" {
  // projects/unified-sensor-327013/locations/us-east1/keyRings/vault-faf5e25875627e02
  key_ring_id = data.google_kms_key_ring.vault.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

resource "google_kms_key_ring_iam_binding" "key_ring-admin" {
  // projects/unified-sensor-327013/locations/us-east1/keyRings/vault-faf5e25875627e02
  key_ring_id = data.google_kms_key_ring.vault.id
  role        = "roles/cloudkms.admin"

  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

resource "google_kms_key_ring_iam_binding" "key_ring-signer" {
  // projects/unified-sensor-327013/locations/us-east1/keyRings/vault-faf5e25875627e02
  key_ring_id = data.google_kms_key_ring.vault.id
  role        = "roles/cloudkms.signerVerifier"

  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"


    members = [
      "serviceAccount:${google_service_account.vault_sa.email}",
    ]
  }
}

// resource "google_kms_key_ring_iam_policy" "key_ring" {
//   key_ring_id = data.google_kms_key_ring.vault.id
//   policy_data = data.google_iam_policy.admin.policy_data
// }
