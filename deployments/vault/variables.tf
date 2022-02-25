variable "project_id" {
  type        = string
  description = "Project ID where Terraform is authenticated to run to create additional projects. If provided, Terraform will create the GKE and Vault cluster inside this project. If not given, Terraform will generate a new project."
}

variable "project" {
  type        = string
  description = "Project ID where Terraform is authenticated to run to create additional projects. If provided, Terraform will create the GKE and Vault cluster inside this project. If not given, Terraform will generate a new project."
}

variable "project_number" {
  type        = string
  description = "Project ID where Terraform is authenticated to run to create additional projects. If provided, Terraform will create the GKE and Vault cluster inside this project. If not given, Terraform will generate a new project."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region in which to create the cluster and run Vault."
}

variable "cluster_name" {
  type        = string
  default     = "gke-cluster-pl"
  description = "Cluster name"
}
variable "bucket_name" {
  type        = string
  default     = "pipeline-test-bucket"
  description = "Bucket name"
}

variable "storage_class" {
  default = "STANDARD"
}

#
# K8S options
// # ------------------------------

#
# GCP options
# ------------------------------
variable "project_services" {
  type = list(string)
  default = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
  ]
  description = "List of services to enable on the project."
}


#
# KMS options
# ------------------------------

variable "kms_key_ring_prefix" {
  type        = string
  default     = "vault-"
  description = "String value to prefix the generated key ring with."
}

variable "kms_key_ring" {
  type        = string
  default     = "vault-unsealer"
  description = "String value to use for the name of the KMS key ring. This exists for backwards-compatability for users of the existing configurations. Please use kms_key_ring_prefix instead."
}

variable "kms_crypto_key" {
  type        = string
  default     = "vault-init"
  description = "String value to use for the name of the KMS crypto key."
}

// variable "vault_image" {
//   description = "Vault docker image (i.e. us.gcr.io/vault-226618/vault:latest)."
//   type        = string
// }
