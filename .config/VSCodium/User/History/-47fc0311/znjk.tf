resource "hcloud_server" "control-planes" {
  for_each    = var.control-plane
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = "nbg1"

  public_net {
    ipv6_enabled = true
  }

  ssh_keys = [for k, v in var.ssh_keys : v.name]

  # connection type, ssh
  connection {
    host = self.ipv4_address
    user = var.custom_user
    type = "ssh"
  }

  labels = {
    vm-type = "cp"
  }

  # cloud init data
  user_data = local_file.cloud-init.content
}
