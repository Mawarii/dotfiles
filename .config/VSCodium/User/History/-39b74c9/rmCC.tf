variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud Token"
  type        = string
}

variable "control-plane" {
  description = "Control Plane List"
  type = map(object({
    name = string
    type = string
    location = string
  }))
}

variable "worker" {
  description = "Worker List"
  type = map(object({
    name = string
    type = string
    location = string
  }))
}

variable "load-balancer" {
  description = "Location of the load balancer"
  type = object({
    type = string
    location = string
  })
}