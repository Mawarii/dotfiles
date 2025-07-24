terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/934/terraform/state/tf-develop-gitlab-managed/lock"
    username       = "wsp-krz-user-personal-token"
    password       = "WjQ5LGcuZWQuwaLs2zLx"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
