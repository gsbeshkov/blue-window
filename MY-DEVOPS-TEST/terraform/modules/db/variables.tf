# terraform/modules/db/variables.tf

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "db_password" {
  description = "The password for the DB user"
  type        = string
  sensitive   = true
}