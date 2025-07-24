resource "hcloud_server" "worker" {
  for_each    = var.worker
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = "nbg1"

  public_net {
    ipv6_enabled = true
  }

  ssh_keys = [for _, name in var.ssh_keys : name.name]

  labels = {
    vm-type = "worker"
  }

  # cloud init data
  user_data = local_file.cloud-init.content

  provisioner "local-exec" {
    when = destroy
    inline = [ 
      "kubectl drain ${self.name} --ignore-daemonsets --delete-emptydir-data",
      "kubectl delete node ${self.name}"
    ]
  }
}
