terraform {
  required_version = ">= 1.3.3"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.0.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.44.0"
    }
  }
}
