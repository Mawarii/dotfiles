terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/892/terraform/state/tf-idp-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/892/terraform/state/tf-idp-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/892/terraform/state/tf-idp-gitlab-managed/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
