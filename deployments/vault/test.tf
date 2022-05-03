resource "random_id" "rand" {
  byte_length = 4
  keepers = {
    bucket_name = var.bucket_name
  }
}


resource "google_storage_bucket" "bucket" {
  name          = lower("${var.bucket_name}-${random_id.rand.hex}")
  location      = var.region # "eu-west"
  project       = var.project
  
  uniform_bucket_level_access = true
  storage_class = var.storage_class
  
  versioning {
    enabled     = true
  }

  cors {
    origin          = ["http://some-example.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  labels = {
    "label1": "label1-value"
    "label2": "label2-value"
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1
    }
  }

  force_destroy = true

  // depends_on = [
  //   google_kms_crypto_key_iam_binding.crypto_key
  // ]
}

// resource "kubernetes_service_account_v1" "vault-auth" {
//   metadata {
//     name = "vault-auth-sa"
//   }
//   // secret {
//   //   name = "${kubernetes_secret_v1.example.metadata.0.name}"
//   // }
// }

resource "google_storage_bucket" "bucket1" {
  name          = lower("${var.bucket_name}-${random_id.rand.hex}")
  location      = "eu-west"
  project       = var.project
  
  uniform_bucket_level_access = true
  storage_class = var.storage_class
  
  versioning {
    enabled     = true
  }

  force_destroy = true

  
  // cors {
  //   origin          = ["http://some-example.com"]
  //   method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  //   response_header = ["*"]
  //   max_age_seconds = 3600
  // }

  // labels = {
  //   "label1": "label1-value"
  //   "label2": "label2-value"
  // }


}