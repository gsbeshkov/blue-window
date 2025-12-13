#!/usr/bin/env bash
set -e

SERVICE=php-app
REGION=europe-west1

gcloud run services describe $SERVICE \
  --region $REGION \
  --format="value(status.url)"

