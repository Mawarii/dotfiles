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
  }
}

# ssh config
ssh_port = "22"
ssh_key = {
  "key1" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhsm+GB6c3YlWLwp+eDz+tlBbxPeJW1TO/baxFQYwwk"
    name = "d.markovic_tuxedo"
  },
  "key2" = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhsm+GB6c3YlWLwp+eDz+tlBbxPeJW1TO/baxFQYwwk"
    name = "d.markovic_tuxedo"
  },
}
