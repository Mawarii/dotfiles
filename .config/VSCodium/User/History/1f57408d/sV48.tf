terraform {
  backend "s3" {
    endpoints = {
      s3 = "fsn1.your-objectstorage.com"
    }
    bucket                      = "monicore-terraform-state"
    key                         = "terraform.tfstate"
    region                      = "fsn1"
    access_key                  = "8GPLSYJZ6DCKFSF0TZA3"
    secret_key                  = "4Y1BisdJwp2E58sC2RFAiTSWHyF9fybmxG5uPBs8"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}
