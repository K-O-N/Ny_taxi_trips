terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  project = "dtc-trips"
  region  = "EU"
  credentials = file("C:/Users/PC/Documents/Project/dtc/Ny_taxi_trips/01-docker-terraform/terraform-setup/keys/google_credentials.json")
}

resource "google_storage_bucket" "auto-expire" {
  name          = "ny-trips-dtc-bucket"
  location      = "EU"
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}