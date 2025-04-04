terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}
provider "google" {
  credentials = "../gcp-creds.json"
  project     = "agri-data-454414"

}

resource "google_storage_bucket" "gcp-storage" {
  name          = var.gcs_bucket_name
  location = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }

    action {
      type = "Delete"
    }
  }
}

resource "google_bigquery_dataset" "bigquery-dataset" {
  dataset_id = var.bq_dataset_name
  location = var.location
  project = "agri-data-454414"
  delete_contents_on_destroy = true
}