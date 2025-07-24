terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.11.0"
    }
  }
}

data "local_file" "cluster_stage_vars" {
  filename = "${path.module}/cluster-stage-vars.yaml"
}

resource "kubectl_manifest" "cluster_stage_vars" {
  yaml_body  =  data.local_file.cluster_stage_vars.content
}

data "local_file" "app_of_apps" {
  filename = "${path.module}/app-of-apps.yaml"
}

resource "kubectl_manifest" "app_of_apps" {
  yaml_body  =  data.local_file.app_of_apps.content
}

data "local_file" "image_pull_secret" {
  filename = "${path.module}/image-pull-secret.yaml"
}

# resource "kubectl_manifest" "image_pull_secret" {
#   yaml_body  =  data.local_file.image_pull_secret.content
# }

# data "local_file" "version_ingress" {
#   filename = "${path.module}/version-ingress.yaml"
# }

# resource "kubectl_manifest" "version_ingress" {
#   yaml_body  =  data.local_file.version_ingress.content
# }
