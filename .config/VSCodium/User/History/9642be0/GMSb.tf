
variable "domain_cluster" {
  description = "Cluster Base Domain"
}

variable "argocd_admin_password" {
  description = "ArgoCD Admin Password"
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argo-cd"
  create_namespace = true
  chart            = "${path.module}/chart"
  reset_values     = true

  set {
    name  = "server.ingress.enabled"
    value = true
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "configs.cm.url"
    value = "https://argocd.${var.domain_cluster}"
  }

  set {
    name  = "server.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.${var.domain_cluster}"
  }

  set {
    name  = "server.ingress.tls[0].secretName"
    value = "argo-tls-secret"
  }

  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = "argocd.${var.domain_cluster}"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }

  set {
    name  = "configs.ssh.extraHosts"
    value = file("${path.module}/ssh/gitlab/known_hosts")
  }

  # wsp ssh gitlab credentials
  set {
    name  = "configs.credentialTemplates.wsp-ssh-creds.url"
    value = "git@gitlab.publicplan.cloud:themenwelt-wirtschaft"
  }

  set {
    name  = "configs.credentialTemplates.wsp-ssh-creds.sshPrivateKey"
    value = file("${path.module}/ssh/gitlab/id_ed25519")
  }

  set {
    name  = "global.image.tag"
    value = "v2.13.8"
  }

  values = ["${file("${path.module}/values-configs.yaml")}"]

}

