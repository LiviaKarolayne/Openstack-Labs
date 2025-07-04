variable "auth_url" {}
variable "tenant_name" {}
variable "user_name" {}
variable "password" {
  sensitive = true
}
variable "region" {
  default = "RegionOne"
}
variable "domain_name" {
  default = "Default"
}
