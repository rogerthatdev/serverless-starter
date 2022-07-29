resource "google_service_account" "event_handler_cloudbuilder" {
  account_id = "event-handler-cloud-builder"
}

resource "google_project_iam_member" "logs_writer_event_handler" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.event_handler_cloudbuilder.email}"
}


resource "google_cloudbuild_trigger" "event_handler_build_trigger" {
  name = "event-handler-build-trigger"

  build {
    images = [
      "us-west2-docker.pkg.dev/citric-sprite-357416/serverless-starter-repo/serverless-starter-event-handler:latest",
    ]
    logs_bucket = "${google_storage_bucket.cloudbuild_logs.url}/logs"
    step {
      args = [
        "build",
        "-t",
        "${local.artifact_registry_url}/serverless-starter-event-handler:latest",
        "-f",
        "Dockerfile",
        ".",
      ]
      dir        = "event-handler"
      env        = []
      name       = "gcr.io/cloud-builders/docker"
      secret_env = []
      wait_for   = []
    }
  }

  github {
    name  = var.repo_name
    owner = var.repo_owner

    push {
      branch       = "main"
      invert_regex = false
    }
  }
  service_account = google_service_account.event_handler_cloudbuilder.id
}

resource "google_service_account" "event_handler_runner" {
  account_id = "event-handler-runner"
}

resource "google_cloud_run_service" "event_handler" {
  name     = "serverless-starter-event-handler"
  location = "us-west2"

  template {
    spec {
      service_account_name = google_service_account.event_handler_runner.email
      containers {
        image = "${local.artifact_registry_url}/serverless-starter-event-handler:latest"
      }
    }
  }
}