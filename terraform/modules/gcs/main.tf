resource "google_storage_bucket" "static" {
  name          = "static-${var.env}-${random_id.suffix.hex}"
  location      = "EU"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

