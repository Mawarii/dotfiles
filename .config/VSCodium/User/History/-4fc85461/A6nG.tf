module "argocd" {
  source = "git::ssh://git@gitlab.publicplan.cloud/iac/efa/cluster-meta/cluster-dependencies.git//terraform"
  argocd_hostname = var.argocd_hostname
  argocd_admin_password = var.argocd_admin_password
  depends_on = [local_file.kubeconfig, helm_release.cilium  ]
}
