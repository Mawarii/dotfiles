variable "argocd_hostname" {
  description = "Ingress Host of the ArgoCD deployment"
}

variable "argocd_admin_password" {
  description = "Password of the ArgoCD Administrator User"
}

# resource "kubernetes_secret" "argocd_redis_secret" {
#   metadata {
#     name = "argocd-redis"
#   }

#   data = {
#     auth = "Shiy6eutopheil4OizeathaechiothieneiYeem3leir7Ic5"
#   }
# } 

resource "helm_release" "argocd" {
  name       = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true

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
    value = "https://${var.argocd_hostname}"
  }

  set {
    name  = "server.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }

  set {
    name  = "server.ingress.hostname"
    value = "${var.argocd_hostname}"
  }

  set {
    name  = "server.ingress.tls[0].secretName"
    value = "argo-tls-secret"
  }

  set {
    name  = "global.domain"
    value = "${var.argocd_hostname}"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }

  set {
    name  = "configs.ssh.extraHosts"
    value = file("${path.module}/ssh/argocd/known_hosts")
  }

  # wsp ssh gitlab credentials
  set {
    name  = "configs.credentialTemplates.efa-deploy.url"
    value = "git@gitlab.publicplan.cloud:"
  }

  set {
    name  = "configs.credentialTemplates.efa-deploy.sshPrivateKey"
    value = file("${path.module}/ssh/argocd/argocd_ed25519_deploy")
  }

  set {
    name  = "global.image.tag"
    value = "v2.13.1"
  }

  values = ["${file("${path.module}/resources/argocd-values.yaml")}"]
}