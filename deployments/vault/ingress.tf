resource "kubernetes_ingress" "vault" {
  wait_for_load_balancer = true

  metadata {
    name = "vault-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "vault-pl-${google_compute_address.external.address}.nip.io"
      http {
        path {
          backend {
            service_name = "vault-ui" // data.kubernetes_service_v1.vault-ui.metadata.0.name
            service_port = 8200
          }
        }
      }
    }

    tls {
      hosts = [
        "vault-pl-${google_compute_address.external.address}.nip.io",

      ]
      secret_name = "vault-tls"
    }
  }
}