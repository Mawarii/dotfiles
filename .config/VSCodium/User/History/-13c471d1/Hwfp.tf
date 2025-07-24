variable "kubernetes_version" {
  type = string
}

variable "crio_version" {
  type = string
}

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
  }))
}

variable "ssh_port" {
  type = string
}

variable "ssh_keys" {
  description = "SSH Key List"
  type = map(object({
    key = string
    name = string
  }))
}

variable "ssh_user" {
  type = string
}

variable "argocd_hostname" {
  description = "Ingress Host of the ArgoCD deployment"
}

variable "argocd_admin_password" {
  description = "Password of the ArgoCD Administrator User"
}
