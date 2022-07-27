variable "project_id" {
  type = string
}

variable "repo_owner" {
  type        = string
  description = "Owner of repository."
}

variable "repo_name" {
  type        = string
  description = "Repository where application code is stored."
}