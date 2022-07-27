terraform {
  backend "gcs" {
    bucket = "serverless-starter-tf"
    prefix = "central/"
  }
}

## Imported bucket
resource "google_storage_bucket" "serverless_starter_tf" {
  force_destroy               = false
  location                    = "US"
  name                        = "serverless-starter-tf"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
