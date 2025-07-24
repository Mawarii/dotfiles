terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
