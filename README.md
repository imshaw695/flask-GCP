# flask-GCP
A repo demonstrating how to put a flask app on GCP

# Install Terraform
- Go to: https://developer.hashicorp.com/terraform/install?product_intent=terraform
Extract the binary to a directory, e.g., C:\Terraform.
Add Terraform to PATH:

Open the Start Search, type in "env", and select "Edit the system environment variables."
In the System Properties window, click on the Environment Variables button.
In the Environment Variables window, find the Path variable in the System variables section and select it. Then, click on Edit.
In the Edit Environment Variable dialog, click on New and add the path to the directory where you extracted the Terraform binary, e.g., C:\Terraform.
Click OK to close all the dialogs.
Restart your machine.
Verify the Installation:

Open a new Command Prompt or PowerShell window.
Type terraform and press Enter. You should see the Terraform help output, indicating that it is correctly installed and available in your PATH.
# Setup GCP Project
- Go to google cloud console: https://cloud.google.com/
- Create a new project
## Step 1: Create a Service Account
Go to the GCP Console:

Navigate to the Google Cloud Console.
Open the IAM & Admin Dashboard:

From the main menu, select IAM & Admin > Service Accounts.
Create a New Service Account:

Click on + CREATE SERVICE ACCOUNT.
Enter a name and description for the service account.
Click CREATE AND CONTINUE.

## Step 2: Assign Roles to the Service Account
Assign Necessary Roles:
You need to assign roles that allow the service account to manage compute instances and deploy applications. The following roles are typically necessary:

Compute Admin: Allows managing compute resources like instances.
Service Account User: Allows the service account to act as other service accounts.
Storage Admin (optional): If you plan to use Google Cloud Storage.
Viewer: General view access to project resources.
In the Grant this service account access to project step, add the roles mentioned above.

Click DONE after assigning the roles.

## Step 3: Create and Download a Key for the Service Account
Create a Key:

Find your newly created service account in the list.
Click on the three dots (⋮) on the right side of the service account row and select Manage keys.
Click ADD KEY > Create new key.
Choose JSON as the key type and click CREATE.
Download the Key:

The JSON key file will be automatically downloaded to your computer. This file contains the credentials needed for Terraform to authenticate with GCP.
Move this file to the google_credentials folder at the top level of the repo and rename it google_credentials.json

## Step 4: Enable compute engine API in the project
Go to APIs and services
Click + Enable APIs and Services
Search for Compute Engine API
Click Enable
# Configure main.tf
- Set the project name for your google project.
- Set the repo url in the clone part

# Deploy
- terraform init
- terraform apply

# Teardown
- terraform destroy

# GCP Budget Hard Stop!
- We can use this repo to create a hard stop, so if we reach £x of spend on a project, we can remove it from the billing account. This will mean the services shut down, so needs to be used carefully.
- https://github.com/Cyclenerd/poweroff-google-cloud-cap-billing

