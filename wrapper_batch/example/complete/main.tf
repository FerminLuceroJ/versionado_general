module "wrapper_batch" {

  source = "../../"

  metadata = local.metadata
  project  = "example"

  batch_parameters = {
    "00" = {
      max_vcpus = 4
    }
  }
  batch_defaults = var.batch_defaults
}