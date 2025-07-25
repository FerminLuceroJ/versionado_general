locals {

  metadata = {
    aws_region  = "us-east-1"
    environment = "Production"

    public_domain  = "democorp.cloud"
    private_domain = "democorp"

    key = {
      company = "dmc"
      region  = "use1"
      env     = "prd"
    }
  }

  project = "example"

  common_name_prefix = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_prefix,
    local.project
  ])

  common_tags = {
    "company"     = local.metadata.key.company
    "provisioner" = "terraform"
    "environment" = local.metadata.environment
    "project"     = local.project
    "created-by"  = "GoCloud.la"
  }

  default_aws_acm_certificate = "*.${local.common_name_prefix}.internal"

  # VPC Name
  vpc_name = local.common_name_prefix
  vpc_cidr = data.aws_vpc.this.cidr_block

}
