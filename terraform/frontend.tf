resource "google_service_account" "frontend_cloudbuilder" {
  account_id = "frontend-cloud-builder"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.frontend_cloudbuilder.email}"
}

resource "google_storage_bucket" "cloudbuild_logs" {
  force_destroy               = false
  location                    = "US"
  name                        = "serverless-starter-cloudbuild-logs"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "cloudbuild_log_writers" {
  bucket = google_storage_bucket.cloudbuild_logs.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.frontend_cloudbuilder.email}"
  ]
}

resource "google_cloudbuild_trigger" "frontend_build_trigger" {
  name = "frontend-build-trigger"

  build {
    images = [
      "us-west2-docker.pkg.dev/citric-sprite-357416/serverless-starter-repo/serverless-starter-frontend:latest",
    ]
    logs_bucket = "${google_storage_bucket.cloudbuild_logs.url}/logs"
    step {
      args = [
        "build",
        "-t",
        "${local.artifact_registry_url}/serverless-starter-frontend:latest",
        "-f",
        "Dockerfile",
        ".",
      ]
      dir        = "frontend"
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
  service_account = google_service_account.frontend_cloudbuilder.id
}

resource "google_cloud_run_service" "frontend" {
  name     = "serverless-starter-frontend"
  location = "us-west2"

  template {
    spec {
      containers {
        image = "${local.artifact_registry_url}/serverless-starter-frontend:latest"
      }
    }
  }
}
# Blocked by org policy
# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# resource "google_cloud_run_service_iam_policy" "noauth" {
#   location    = google_cloud_run_service.frontend.location
#   project     = google_cloud_run_service.frontend.project
#   service     = google_cloud_run_service.frontend.name

#   policy_data = data.google_iam_policy.noauth.policy_data
# }
