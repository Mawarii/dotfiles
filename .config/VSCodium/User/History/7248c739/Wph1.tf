data "http" "hetzner_ssh_keys" {
  url = "https://api.hetzner.cloud/v2/ssh_keys"

  request_headers = {
    Authorization = "Bearer ${var.hcloud_token}"
  }
}
