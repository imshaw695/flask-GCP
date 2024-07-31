#!/bin/bash

# Log everything to a file for debugging
exec > /var/log/startup-script.log 2>&1
set -x

echo "Starting the startup script..."

# Update and install necessary packages
echo "Updating and installing packages..."
apt-get update
apt-get install -y python3 python3-pip git jq
pip3 install flask

# Fetch the SSH key from Secret Manager
echo "Fetching the SSH key from Secret Manager..."
SECRET_NAME="github-ssh-key"
PROJECT_ID="flask-gcp-431011"
SECRET_VERSION="latest"

# Authenticate with Google Cloud using the VM's service account (no need for additional authentication)
echo "Authenticating with Google Cloud..."

# Retrieve the secret and store it in a variable
echo "Retrieving the secret..."
PRIVATE_KEY=$(gcloud secrets versions access ${SECRET_VERSION} --secret=${SECRET_NAME})

# Ensure the PRIVATE_KEY variable is not empty
if [ -z "$PRIVATE_KEY" ]; then
  echo "Error: PRIVATE_KEY is empty."
  exit 1
fi

# Store the SSH key in the .ssh directory
echo "Storing the SSH key..."
mkdir -p /root/.ssh
echo "$PRIVATE_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

# Add GitHub to known hosts
echo "Adding GitHub to known hosts..."
ssh-keyscan github.com >> /root/.ssh/known_hosts

# Ensure /opt directory has the correct permissions
echo "Setting permissions for /opt directory..."
sudo mkdir -p /opt/flask-app
sudo chown -R $(whoami):$(whoami) /opt/flask-app

# Clone the private repository using SSH
echo "Cloning the private repository..."
git clone git@github.com:imshaw695/flask-GCP.git /opt/flask-app

# Verify if the repository was cloned successfully
if [ ! -d "/opt/flask-app" ]; then
  echo "Error: Repository not cloned."
  exit 1
fi

# Change to the app directory and install dependencies
echo "Installing dependencies..."
cd /opt/flask-app
pip3 install -r app/requirements.txt

# Start the Flask app
echo "Starting the Flask app..."
gunicorn --bind 0.0.0.0:5000 app.app:app

echo "Startup script completed."
