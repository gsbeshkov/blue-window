# Cloud Run & PHP DevOps Challenge

This repository contains the infrastructure and application code for a PHP-FPM Nginx stack hosted on Google Cloud Run. It includes a complete CI/CD pipeline using GitHub Actions and Infrastructure as Code using Terraform.

## Project Structure

* `app/`: Source code for the PHP application and Docker configuration.
* `terraform/`: Infrastructure definitions (Cloud SQL, Cloud Run, Load Balancer).
* `scripts/`: Utility scripts for post-deployment tasks.
* `.github/workflows/`: Automated deployment pipeline.

## Prerequisites

To run this locally or deploy, you need:

1.  **Google Cloud Project**: A valid GCP project ID.
2.  **Terraform**: Installed (v1.0+).
3.  **Gcloud CLI**: Installed and authenticated.
4.  **GitHub Secrets**: Set `GCP_PROJECT_ID` and `GCP_SA_KEY` in your repo settings for the pipeline to work.

## 1. Infrastructure Deployment (Terraform)

The infrastructure is modularized. The database lives in a reusable module.

1.  **Navigate to the folder:**
    ```bash
    cd terraform
    ```

2.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

3.  **Plan and Apply:**
    You will be prompted for your Project ID and a Database Password.
    ```bash
    terraform apply
    ```
    *Note: The initial apply creates a Cloud Run service with a "Hello World" placeholder image. The actual PHP app is deployed via the CI/CD pipeline.*

## 2. Application Deployment (CI/CD)

Deployments are automated.

1.  Push any change to the `main` branch.
2.  GitHub Actions will:
    * Build the Docker image (Alpine + Nginx + PHP 8.1).
    * Push it to Google Container Registry (GCR).
    * Update the existing Cloud Run service with the new image.

## 3. Usage & Verification

Once deployed, you can access the application via the Load Balancer IP.

**Retrieve the IP:**
Use the provided helper script. Replace `YOUR_PROJECT_ID` with your actual ID.

```bash
./scripts/get-ip.sh YOUR_PROJECT_ID