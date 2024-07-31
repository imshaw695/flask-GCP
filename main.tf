provider "google" {
  credentials = file("${path.module}/google_credentials/google_credentials.json")
  project     = "flask-gcp-431011"
  region      = "europe-west2"  # UK (London) region
}

resource "google_compute_instance" "flask-app" {
  name         = "flask-app"
  machine_type = "e2-micro"
  zone         = "europe-west2-a"  # Zone in the UK (London) region

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  service_account {
    email  = "flask-service-account@flask-gcp-431011.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    enable-serial-console = "true"
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")
}

output "instance_ip" {
  value = google_compute_instance.flask-app.network_interface[0].access_config[0].nat_ip
}