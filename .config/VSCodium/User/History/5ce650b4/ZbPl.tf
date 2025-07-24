resource "hcloud_server" "worker" {
  for_each    = var.worker
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = each.value.location
  delete_protection = true
  rebuild_protection = true

  public_net {
    ipv6_enabled = true
  }

  labels = {
    vm-type = "worker"
  }
}
