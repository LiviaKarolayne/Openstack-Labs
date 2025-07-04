terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
}

resource "openstack_identity_project_v3" "domains" {
  for_each = var.domains

  name        = each.value.name
  description = each.value.description
  enabled     = each.value.enabled
  is_domain   = true
}

resource "openstack_identity_project_v3" "projects" {
  for_each = var.projects

  name        = each.value.name
  description = each.value.description
  enabled     = each.value.enabled
}
