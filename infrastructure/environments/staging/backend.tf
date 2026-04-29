terraform {
    backend "gcs" {
        bucket = "terraform-backend-gcp-ali"
        prefix = "staging/terraform.tfstate"
    }
}

