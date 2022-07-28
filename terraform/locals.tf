locals {
  services = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com"
  ]
  artifact_registry_url = format("%s-docker.pkg.dev/%s/%s", google_artifact_registry_repository.docker_images.location, var.project_id, google_artifact_registry_repository.docker_images.name)
  cloudbuilders         = [
    "serviceAccount:${google_service_account.frontend_cloudbuilder.email}",
    "serviceAccount:${google_service_account.event_handler_cloudbuilder.email}"
  ]
}
