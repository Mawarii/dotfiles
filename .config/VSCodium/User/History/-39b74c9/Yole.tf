variable "hcloud_token" {
  sensitive   = true
  description = "HCloud Token"
  type        = string
}

variable "control-plane" {
  description = "Control Plane List"
  type = map(object({
    name = string
    type = string
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

variable "ssh_port" {
  type = string
}
