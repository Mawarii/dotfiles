terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49.1"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "~> 2.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
