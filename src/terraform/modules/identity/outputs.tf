output "domain_ids" {
  description = "Domains created successfully"
  value = {
    for k, domain in openstack_identity_project_v3.domains :
    k => domain.id
  }
}

output "project_ids" {
  description = "Projects created successfully"
  value = {
    for k, project in openstack_identity_project_v3.projects :
    k => project.id
  }
}
