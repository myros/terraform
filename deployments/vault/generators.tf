

# Generate a random suffix for the KMS keyring. Like projects, key rings names
# must be globally unique within the project. A key ring also cannot be
# destroyed, so deleting and re-creating a key ring will fail.
#
# This uses a random_id to prevent that from happening.
resource "random_id" "kms_random" {
  prefix      = var.kms_key_ring_prefix
  byte_length = "8"
}

resource "random_integer" "number" {
  min = 1
  max = 50000
}

resource "random_string" "this" {
  length           = 5
  special           = false
  lower           = true
  upper           = false
}

resource "random_id" "instance_id" {
 byte_length = 8
}
