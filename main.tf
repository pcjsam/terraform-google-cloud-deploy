resource "google_clouddeploy_delivery_pipeline" "cloud_deploy_delivery_pipeline" {
  location = var.project_region
  name     = var.pipeline_name

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.development_multi_target.target_id
      profiles  = ["development"]
    }
    stages {
      target_id = google_clouddeploy_target.production_multi_target.target_id
      profiles  = ["production"]
    }
  }
}

resource "google_clouddeploy_target" "development_child_targets" {
  for_each = { for item in var.development_targets : "${item.project_id}-${item.region}" => item }

  location = var.project_region
  name     = "${var.target_prefix}dev-${each.value.region}"

  deploy_parameters = try(each.value.deploy_parameters, null)

  run {
    location = "projects/${each.value.project_id}/locations/${each.value.region}"
  }
}

resource "google_clouddeploy_target" "development_multi_target" {
  location = var.project_region
  name     = "${var.target_prefix}dev"

  multi_target {
    target_ids = [for target in google_clouddeploy_target.development_child_targets : target.target_id]
  }
}

resource "google_clouddeploy_target" "production_child_targets" {
  for_each = { for item in var.production_targets : "${item.project_id}-${item.region}" => item }

  location = var.project_region
  name     = "${var.target_prefix}prd-${each.value.region}"

  deploy_parameters = try(each.value.deploy_parameters, null)

  run {
    location = "projects/${each.value.project_id}/locations/${each.value.region}"
  }
}

resource "google_clouddeploy_target" "production_multi_target" {
  location = var.project_region
  name     = "${var.target_prefix}prd"

  multi_target {
    target_ids = [for target in google_clouddeploy_target.production_child_targets : target.target_id]
  }
}
