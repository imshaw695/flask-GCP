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

  metadata = {
    enable-serial-console = "true"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip git
    pip3 install flask
    git clone https://github.com/imshaw695/flask-GCP.git /opt/flask-app
    cd /opt/flask-app
    pip3 install -r requirements.txt
    gunicorn --bind 0.0.0.0:5000 app:app
  EOF
}

output "instance_ip" {
  value = google_compute_instance.flask-app.network_interface[0].access_config[0].nat_ip
}