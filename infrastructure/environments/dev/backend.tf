terraform {
    backend "gcs" {
        bucket = "terraform-backend-gcp-ali"
        prefix = "dev/terraform.tfstate"
    }
}

