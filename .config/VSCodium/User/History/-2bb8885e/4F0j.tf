resource "hcloud_server" "control-planes" {
  for_each    = var.control-plane
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = each.value.location
  delete_protection = true
  rebuild_protection = true

  public_net {
    ipv6_enabled = true
  }

  ssh_keys = [  ]

  # connection type, ssh
  connection {
    host = self.ipv4_address
    type = "ssh"
  }

  labels = {
    vm-type = "cp"
  }
}
