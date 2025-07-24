data "template_file" "cilium-values" {
  template = file("helm/cilium.yaml")
  vars = {
    cluster_address = hcloud_rdns.rdns-lb.dns_ptr
  }

  depends_on = [hcloud_rdns.rdns-lb]
}

resource "helm_release" "cilium" {
  name      = "cilium"
  chart     = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  version    = "1.14.9"

  values = [data.template_file.cilium-values.rendered]

  depends_on = [
    local_file.kubeconfig,
    ssh_resource.join_command,
    ssh_resource.certificate,
    ssh_resource.join-cp,
    ssh_resource.join-worker
  ]
}

resource "kubectl_manifest" "hcloud-csi-token" {
  yaml_body = <<-YAML
# secret.yml
apiVersion: v1
kind: Secret
metadata:
  name: hcloud
  namespace: kube-system
stringData:
  token: "${var.hcloud_token}"
YAML

  depends_on = [helm_release.cilium]
}

resource "helm_release" "hcloud-csi" {
  name             = "hcloud-csi-provider"
  chart            = "hcloud-csi"
  create_namespace = true
  namespace        = "kube-system"

  repository = "https://charts.hetzner.cloud"
  version    = "2.11.0"

  #values = ["${file("helm/nginx-ingress.yaml")}"]

  depends_on = [
    helm_release.cilium,
    kubectl_manifest.hcloud-csi-token
  ]
}
