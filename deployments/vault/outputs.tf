
output "region" {
  value       = var.region
  description = "Region"
}

output "kubernetes_cluster_name" {
  value       = data.google_container_cluster.this.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = data.google_container_cluster.this.endpoint
  description = "GKE Cluster Host"
}

// output "vault_ip_address" {
//   value = data.kubernetes_service_v1.vault-deployment.status.0.load_balancer.0.ingress.0.ip
// }

// output "dashboard_ip_address" {
//   value = data.kubernetes_service_v1.dashboard-deployment.status.0.load_balancer.0.ingress.0.ip
// }


output "service-account" {
  value       = google_service_account.vault_sa.email
  description = "GKE Cluster Host"
}

output "keyring" {
  value       = data.google_kms_key_ring.vault.id
  description = "GKE Cluster Host"
}

output "keyring-name" {
  value       = data.google_kms_key_ring.vault.name
  description = "GKE Cluster Host"
}

output "vault-ip" {
  value = "https://${var.vault_release_name}-${data.google_compute_address.external.address}.nip.io"
}

// output "templates" {
//   value = null_resource.your_deployment
// }

// output "vault_ca" {
//   value = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault-ca.cert_pem}"
// }
// output "vault_crt" {
//   value = tls_private_key.vault.private_key_pem
//   sensitive = true
// }
// output "vault_key" {
//   value = tls_self_signed_cert.vault-ca.cert_pem
// }

// output "template" {
//   value       = templatefile("${path.module}/values-raft.yaml", {
//       keyring = google_kms_key_ring.vault.name
//     })
//   description = "GKE Cluster Host"
// }


// "vault_ca" = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault-ca.cert_pem}"
//     "vault_crt" = tls_private_key.vault.private_key_pem
//     "vault_key"    = tls_self_signed_cert.vault-ca.cert_pem

// gcloud container clusters get-credentials (terraform output -raw kubernetes_cluster_name) --region (terraform output -raw region)