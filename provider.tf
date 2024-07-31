terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.39.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "dsb-innovation-hub"
  region  = "us-central1"
}