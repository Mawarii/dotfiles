terraform {
  backend "s3" {
    endpoints = {
      s3 = "fsn1.your-objectstorage.com"
    }
    bucket     = "monicore-terraform-state"
    key        = "terraform.tfstate"
    region     = "eu-central-1"
    access_key = "8GPLSYJZ6DCKFSF0TZA3"
    secret_key = "4Y1BisdJwp2E58sC2RFAiTSWHyF9fybmxG5uPBs8"
  }
}
