resource "kubernetes_ingress" "vault" {
  wait_for_load_balancer = true

  metadata {
    name = "${var.vault_release_name}-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      "cert-manager.io/cluster-issuer" = "le-production"
    }
  }

  spec {
    rule {
      host = "${var.vault_release_name}-${data.google_compute_address.external.address}.nip.io"
      http {
        path {
          backend {
            service_name = "${var.vault_release_name}-ui" // data.kubernetes_service_v1.vault-ui.metadata.0.name
            service_port = 8200
          }
        }
      }
    }

    tls {
      hosts = [
        "${var.vault_release_name}-${data.google_compute_address.external.address}.nip.io",

      ]
      secret_name = "${var.vault_release_name}-tls"
    }
  }
}