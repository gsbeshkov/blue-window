provider "google" {
  project = var.project_id
  region  = var.region
}

module "static" {
  source = "./modules/gcs"
  env    = var.env
}

module "db" {
  source  = "./modules/cloudsql"
  db_name = var.db_name
  region  = var.region
}

module "app" {
  source        = "./modules/cloudrun"
  image         = var.image
  region        = var.region
  bucket_name   = module.static.bucket_name
  db_connection = module.db.connection_name
}

module "lb" {
  source     = "./modules/lb"
  region     = var.region
  run_service = module.app.service_name
}

