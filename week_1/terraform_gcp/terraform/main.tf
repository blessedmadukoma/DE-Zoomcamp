terraform {
  required_version = ">=1.0"
  # backend "gcs" {
  #   bucket  = "terraform-state-2021"
  #   prefix  = "terraform/state"
  # }
  backend "local" {}

  # not needed because we already defined "provider google"
  # required_providers {
  #   google = {
  #     source  = "hashicorp/google"
  #     version = "3.5.0"
  #   }
  # }
}

provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials)
}

# Data Lake bucket
resource "google_storage_bucket" "datalake-bucket" {
  name     = "${var.gcs_bucket_name}_${var.project}"
  location = var.region

  # optional but recommended settings:
  # storage_class               = var.gcs_storage_class
  # uniform_bucket_level_access = true

  # versioning {
  #   enabled = true
  # }

  lifecycle_rule {
    condition {
      age = 30 // days
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  force_destroy = true
}


# BigQuery Dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset_name
  project    = var.project
  location   = var.region

}
