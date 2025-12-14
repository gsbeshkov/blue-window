#!/bin/bash

# ==========================================
# Script: get-ip.sh
# Description: Retrieves the Public IP of the Global Load Balancer
# Usage: ./get-ip.sh <PROJECT_ID>
# ==========================================

# 1. Logging Function
# Simple timestamped logging for easier debugging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# 2. Argument Parsing & Validation
# We expect the Project ID as the first argument
PROJECT_ID=$1

if [ -z "$PROJECT_ID" ]; then
    echo "Error: No Project ID provided."
    echo "Usage: ./get-ip.sh <PROJECT_ID>"
    exit 1
fi

log "Starting IP retrieval for Project: $PROJECT_ID"

# 3. Fetching the IP
# We look for the forwarding rule named 'app-forwarding-rule' which we defined in Terraform.
# We use || to catch errors if the gcloud command fails.
LB_IP=$(gcloud compute forwarding-rules list \
    --project="$PROJECT_ID" \
    --filter="name=app-forwarding-rule" \
    --format="value(IPAddress)" \
    --global 2>/dev/null) || {
        log "Error: Failed to execute gcloud command. Check your permissions or Project ID."
        exit 1
    }

# 4. Result Output
if [ -z "$LB_IP" ]; then
    log "Error: Load Balancer IP not found. Is the Terraform infrastructure deployed?"
    exit 1
else
    echo "------------------------------------------------"
    echo "Success! The Load Balancer Public IP is:"
    echo "$LB_IP"
    echo "------------------------------------------------"
    log "Script finished successfully."
fi