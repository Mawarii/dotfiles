terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
