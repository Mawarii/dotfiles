terraform {
  backend "s3" {
    bucket     = "mybucket"
    key        = "path/to/my/key"
    region     = "us-east-1"
    access_key = "8GPLSYJZ6DCKFSF0TZA3"
    secret_key = "4Y1BisdJwp2E58sC2RFAiTSWHyF9fybmxG5uPBs8"
  }
}
