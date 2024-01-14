locals {
  datalake_bucket = "de_zoomcamp_datalake"
}

variable "project" {
  description = "Project"
  default     = "de-zoomcamp-410913"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "credentials" {
  description = "Credentials"
  default     = "de-zoomcamp-410913-ff0c577f1526.json"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  # type        = string
  default = "de_taxi_trips"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "de-zoomcamp-410913-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "table_name" {
  description = "My BigQuery Table Name"
  default     = "de_nyc_trips"

}
