module "vault-jwt-token" {
  source = "matti/resource/shell"
  
  version   = "1.5.0"
  command = "kubectl exec -it vault-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/token"

  depends_on = [
    helm_release.vault
  ]
}

output "vault-jwt-token" {
  value = module.vault-jwt-token.stdout
}

// output "token_reviewer_jwt" {
//   value = data.vault_kubernetes_auth_backend_config.config.token_reviewer_jwt
// }