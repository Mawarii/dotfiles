hcloud_token = "fJMEZbIpJKcI6WVbpFtUYiUwYgsiABvvLMkWeIQbEGEUsNLiwQtrZ0FYJx062ftQ"

# the crio version wanted
# bumped to >1.28, starting with 1.28 there is a repo change. (https://github.com/cri-o/packaging/blob/d12f75b1322d9f8ef90559f51ea55fc09943d3aa/README.md#usage)
crio_version = "1.31"

# kubernetes version
kube_version = "1.31"

control-plane = {
  "cp-1" = {
    name = "controlplane-001"
    type = "cx32"
  },
  "cp-2" = {
    name = "controlplane-002"
    type = "cx32"
  },
  "cp-3" = {
    name = "controlplane-003"
    type = "cx32"
  }
}

worker = {
  "w-1" = {
    name = "worker-001"
    type = "cx42"
  },
  "w-2" = {
    name = "worker-002"
    type = "cx42"
  },
  "w-3" = {
    name = "worker-003"
    type = "cx42"
  },
  "w-4" = {
    name = "worker-004"
    type = "cx42"
  }
}

# SSH config
ssh_user = "shield"

ssh_port = "22222"

ssh_keys = {
  "key1" = {
    key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1DqX4WwuIj63upMyfm3le8FY0rg820UXqO3H1IZfW/gjfDhIB8glMXUrusg4OsnFy1JLfSZAwxSq7NRFn46R09YrLPP9A2UaByqv3TBegcK/oSIQlOJvY7b3nS2QCFv+vfCwghngPCMsVO0hVcDROQIZFYprnkw3l1BNd2LIx95zR1y1kfHkE6pbXj5mC6PcgKTybqP3WLFYzxI3wh6n+vY7OmQnWsOwh2YFU2CPRbdIHNdtQK54SS0UbJ622w0wyhafBSN4xuzpZP/Iw+OFSv0fD1vEdt3gRYsZEM6cztjbYqsYHaDK5SraIIzoawJKPU6con3pb4tmlTkmtKHLR chris0607@PublicPlan-MBP"
    name = "c.meier_mbp"
  },
  "key2" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhsm+GB6c3YlWLwp+eDz+tlBbxPeJW1TO/baxFQYwwk"
    name = "d.markovic_tuxedo"
  },
  "key3" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+Dz3l3Ahc+sU1Fhpd8I0iB9wp8o6Xw50nRcmTP5cUp"
    name = "d.lehmann_tuxedo"
  },
  "key4" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADYvMgi64SEjZmbj9aJXIwxV1xJt+dsaa7RyJM2Eql2"
    name = "i.mende_mbp"
  },
  "key5" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnzMxELq+6/KOSmQwxHkPQRmP2yWP8dyOM23bZxbeQV"
    name = "n.merscher_mbp"
  },
  "key6" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF7zDOa0SKcp9fQA+VrAUBPA6BmjJLJKQBLL6iky9Tx"
    name = "r.weingart_thinkpad"
  }
}

# Base Password: eaxaegae7een2AelaShah0enahv0ahth3bi8ietu6ahu0vei
argocd_admin_password="$2a$12$lQ3erFHKsHLUhORhtGP2zuB2674o5CXwN3pUhENfCtXXninfAi5O6"
argocd_hostname="argocd.efa.publicplan.example.com"
