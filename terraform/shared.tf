resource "google_artifact_registry_repository" "docker_images" {
  location      = "us-west2"
  repository_id = "serverless-starter-repo"
  description   = "Docker images for serverless starter"
  format        = "DOCKER"
}

output "artifact_registry_url" {
  value = format("%s-docker.pkg.dev/%s/%s", google_artifact_registry_repository.docker_images.location, var.project_id, google_artifact_registry_repository.docker_images.name)
}

resource "google_artifact_registry_repository_iam_binding" "cloudbuilders" {
  repository = google_artifact_registry_repository.docker_images.name
  location   = google_artifact_registry_repository.docker_images.location
  role       = "roles/artifactregistry.writer"
  members    = local.cloudbuilders
}