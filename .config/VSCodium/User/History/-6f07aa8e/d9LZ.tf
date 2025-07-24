terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/1443/terraform/state/tf-efa-develop-gitlab-managed/lock"
    username       = "gitlab-ci-token"
    password       = "Uu7Zxv9nUo5d2zJx8UYH"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
