terraform {
  backend "http" {
    address        = "https://gitlab.publicplan.cloud/api/v4/projects/897/terraform/state/tf-pre-stage-gitlab-managed"
    lock_address   = "https://gitlab.publicplan.cloud/api/v4/projects/897/terraform/state/tf-pre-stage-gitlab-managed/lock"
    unlock_address = "https://gitlab.publicplan.cloud/api/v4/projects/897/terraform/state/tf-pre-stage-gitlab-managed/lock"
    username       = "wsp-krz-user-personal-token"
    password       = "2oDLr4cSUTWSnXDmXpy8"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
