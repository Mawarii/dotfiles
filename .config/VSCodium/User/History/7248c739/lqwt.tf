data "http" "hetzner_ssh_keys" {
  url = "https://api.hetzner.cloud/v1/ssh_keys"

  request_headers = {
    Authorization = "Bearer ${var.hcloud_token}"
  }
}

output "hetzner_ssh_keys" {
  value = data.http.hetzner_ssh_keys.body
}
