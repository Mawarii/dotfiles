resource "hcloud_server" "control-planes" {
  for_each    = var.control-plane
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = each.value.location

  ssh_keys = jsondecode(data.http.hetzner_ssh_keys.response_body)["ssh_keys"][*]["name"]

  public_net {
    ipv6_enabled = true
  }

  labels = {
    vm-type = "cp"
  }

  lifecycle {
    ignore_changes = [ ssh_keys ]
  }
}
