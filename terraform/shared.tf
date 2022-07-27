resource "google_artifact_registry_repository" "docker_images" {
  location      = "us-west2"
  repository_id = "serverless-starter-repo"
  description   = "Docker images for serverless starter"
  format        = "DOCKER"
}

output "artifact_registry_url" {
    value = format("%s-docker.pkg.dev/%s/%s", google_artifact_registry_repository.docker_images.location, var.project_id, google_artifact_registry_repository.docker_images.name)
}
# TODO: add IAM binding to above repo for cloud build service account(s)
# resource "google_artifact_registry_repository_iam_binding" "binding" {
#   project = google_artifact_registry_repository.my-repo.project
#   location = google_artifact_registry_repository.my-repo.location
#   repository = google_artifact_registry_repository.my-repo.name
#   role = "roles/artifactregistry.reader"
#   members = [
#     "user:jane@example.com",
#   ]
# }