control-plane = {
  "cp-1" = {
    name = "controlplane-001"
    type = "cpx21"
    location = "hel1"
  },
  "cp-2" = {
    name = "controlplane-002"
    type = "cpx21"
    location = "hel1"
  }
}

load_balancer_location = "hel1"

worker = {
  "w-1" = {
    name = "worker-001"
    type = "cpx31"
    location = "nbg1"
  },
  # "w-2" = {
  #   name = "worker-002"
  #   type = "cpx31"
  #   location = "hel1"
  # }
}
