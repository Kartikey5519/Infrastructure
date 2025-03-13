terraform {
  backend "s3" {
    bucket  = "terraform-state"
    profile = "default"
    encrypt = true
    key     = "<bucket_name>/terraform.tfstate"
    region  = "<region_name>"
  }
}
