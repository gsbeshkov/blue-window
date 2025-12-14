terraform {
  required_version = ">= 1.0"
  
  # HOSTING STATE REMOTELY
  backend "gcs" {
    bucket  = "gbeshkov-tf-state" 
    prefix  = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}