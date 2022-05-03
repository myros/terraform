# kubectl create configmap nginx-purge-cache-lua --from-file purge-multi.lua=purge-cache.lua --dry-run -o yaml | kubectl apply -f -

// data "kubernetes_namespace" "vault" {
//   metadata {
//     name = "vault"
//   }
// }

resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "vault"

  }

}


resource "helm_release" "external-secrets" {
  name  = "external-secrets"
  namespace = "vault"
  description = "External secrets"
  chart = "external-secrets"
  repository = "https://charts.external-secrets.io"

  depends_on = [
    kubernetes_namespace.vault
  ]

}

resource "helm_release" "vault" {
  name  = var.vault_release_name
  namespace = "vault"
  description = "test vault"
  chart = "vault"
  # create_namespace = true
  repository = "https://helm.releases.hashicorp.com"
  values = [
    templatefile("${path.module}/values-raft.yaml", {
      keyring = local.kms_key_ring,
      cryptokey = var.kms_crypto_key
      project_id = var.project_id,
      region = var.region,
      vault-tls = local.vault_tls_name
    })
  ]
  // lbip = google_compute_address.static.address
  // values = [
  //   "${file("values-raft.yaml")}"
  // ]

  depends_on = [
    kubernetes_namespace.vault
  ]
}


#
# K8S DASHBOARD
# -----------------------------

resource "helm_release" "helm-rancher" {
  count = 0
  name       = "rancher-pl"
  chart      = "rancher-stable/rancher"

  set {
    name  = "bootstrapPassword"
    value = "123123m"
  }

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "tls"
    value = "external"
  }
}
// resource "helm_release" "helm-rancher" {
//   name       = "rancher"

//   // namespace = "cattle-system"

//   # repository = "rancher-latest/rancher"
//   chart      = "rancher-stable/rancher"

//   values = [
//     # "${file("values.yaml")}"
//   ]

//   set {
//     name  = "bootstrapPassword"
//     value = "123123m"
//   }

//   set {
//     name  = "ingress.enabled"
//     value = "false"
//   }

//   # set {
//   #   name  = "letsEncrypt.email"
//   #   value = "miroslav.milak@gmail.com"
//   # }

//   # set {
//   #   name  = "letsEncrypt.ingress.class"
//   #   value = "nginx"
//   # }

//   # set {
//   #   name  = "metadata.annotations.cert-manager.io/cluster-issuer"
//   #   value = "le-production"
//   # }

//   # set {
//   #   name  = "ingress.extraAnnotations\\.cert-manager/cluster-issuer"
//   #   value = "le-production"
//   #   # value = jsonencode({
//   #   #   "cert-manager.io/cluster-issuer": "le-production",
//   #   #   "cert-manager.io/issuer": "ClusterIssuer"
//   #   # })
//   # }

// }
