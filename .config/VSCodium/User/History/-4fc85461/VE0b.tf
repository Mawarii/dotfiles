module "argocd" {
  source = "git::ssh://git@gitlab.publicplan.cloud/iac/efa/cluster-meta/cluster-dependencies.git//terraform"
  depends_on = [ helm_release.cilium ]
}
