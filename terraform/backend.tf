terraform {
  backend "gcs" {
    bucket  = "tf-state-devops-test"
    prefix  = "env/dev"
  }
}

