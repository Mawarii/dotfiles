terraform {
  backend "s3" {
    endpoints = {
      s3 = "fsn1.your-objectstorage.com"
    }
    bucket                      = "monicore-terraform-state"
    key                         = "terraform.tfstate"
    region                      = "fsn1"
    access_key                  = var.hcloud_s3_access_key
    secret_key                  = var.hcloud_s3_secret_key
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}
