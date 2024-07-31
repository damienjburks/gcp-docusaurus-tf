resource "google_storage_bucket" "artifacts" {
  name          = "724455289756-docusaurus-bucket"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_binding" "artifacts_binding" {
  bucket = google_storage_bucket.artifacts.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_storage_bucket_iam_binding" "logs_bucket_binding" {
  bucket = "724455289756-us-central1-cloudbuild-logs"
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_storage_bucket_iam_binding" "ae_staging_bucket_binding" {
  bucket = "staging.dsb-innovation-hub.appspot.com"
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}


resource "google_cloudbuildv2_repository" "default" {
  name              = "gcp-docusaurus"
  parent_connection = "projects/dsb-innovation-hub/locations/us-central1/connections/damienjburks"
  remote_uri        = "https://github.com/damienjburks/gcp-docusaurus.git"
}

resource "google_cloudbuild_trigger" "default" {
  name        = "ghe-trigger-gcp-docusaurus"
  location    = "us-central1"
  description = "Trigger for gcp-docusaurus"

  repository_event_config {
    repository = google_cloudbuildv2_repository.default.id
    push {
      branch = "^main$"
    }
  }

  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  filename           = "cloudbuild.yaml"
  service_account    = google_service_account.default.id
}

resource "google_service_account" "default" {
  account_id   = "codebuild-trigger"
  display_name = "ghe-cloudbuild-trigger"
}

resource "google_project_iam_custom_role" "default" {
  role_id     = "gheCloudbuildCustomRole"
  title       = "GHE CloudBuild Trigger Role"
  description = "A custom role for GHE CloudBuild Trigger"
  permissions = [
    "source.repos.get",
    "source.repos.list",
    "cloudbuild.builds.create",
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudbuild.builds.update",
    "cloudbuild.operations.get",
    "cloudbuild.operations.list",
    "remotebuildexecution.blobs.get",
    "logging.logEntries.create",
    "logging.logEntries.route"
  ]
}
resource "google_project_iam_binding" "default" {
  project = "dsb-innovation-hub"
  role    = google_project_iam_custom_role.default.id

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}


resource "google_project_iam_binding" "appengine_deployer" {
  project = "dsb-innovation-hub"
  role    = "roles/appengine.deployer"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_project_iam_binding" "appengine_app_admin" {
  project = "dsb-innovation-hub"
  role    = "roles/appengine.appAdmin"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_project_iam_binding" "appengine_service_admin" {
  project = "dsb-innovation-hub"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
resource "google_project_iam_binding" "cloudbuild_edit_binding" {
  project = "dsb-innovation-hub"
  role    = "roles/cloudbuild.builds.editor"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_project_iam_binding" "storage_obj_admin_binding" {
  project = "dsb-innovation-hub"
  role    = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_service_account_iam_binding" "assume_ae_svc_account_binding" {
  service_account_id = "projects/dsb-innovation-hub/serviceAccounts/dsb-innovation-hub@appspot.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}