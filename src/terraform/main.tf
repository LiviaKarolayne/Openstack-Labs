terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53"
    }
  }
}

provider "openstack" {
  auth_url    = var.auth_url
  tenant_name = var.tenant_name
  user_name   = var.user_name
  password    = var.password
  region      = var.region
  domain_name = var.domain_name
}

module "identity" {
  source = "./modules/identity"

  domains = {
    local = {
      name        = "openstack.local"
      description = ""
      enabled     = true
    }
  }

  projects = {
    dev = {
      name        = "dev"
      description = ""
      enabled     = true
    }
    hml = {
      name        = "hml"
      description = ""
      enabled     = true
    }
    prd = {
      name        = "prd"
      description = ""
      enabled     = true
    }
  }
}
