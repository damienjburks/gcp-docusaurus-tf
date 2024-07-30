resource "google_cloudbuildv2_repository" "default" {
  name = "gcp-docusaurus"
  parent_connection = "projects/dsb-innovation-hub/locations/us-central1/connections/damienjburks"
  remote_uri = "https://github.com/damienjburks/gcp-docusaurus.git"
}

resource "google_cloudbuild_trigger" "default" {
  repository_event_config {
    repository = google_cloudbuildv2_repository.default.id
  }

  filename = "cloudbuild.yaml"
}