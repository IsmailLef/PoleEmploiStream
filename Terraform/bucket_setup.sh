#!/bin/bash
# This file is used in ci/cd to make sure that we save
# the terraform state

# Specify the content to append
APPEND_CONTENT=$(cat <<EOL
terraform {
  backend "gcs" {
    bucket = "ci-cd-terra-state"
    credentials = "access.json"
  }
}
EOL
)

# Specify the path to the config.tf file
BACKEND_FILE="backend.tf"

# Append the content to the file
echo "$APPEND_CONTENT" >> "$BACKEND_FILE"
echo "Content appended to $BACKEND_FILE."
