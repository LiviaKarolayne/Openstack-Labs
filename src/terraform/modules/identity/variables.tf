variable "domains" {
  description = "Map of domains"
  default     = {}
  type = map(object({
    name        = string
    description = string
    enabled     = bool
  }))
}

variable "projects" {
  description = "Map of projects"
  default     = {}
  type = map(object({
    name        = string
    description = string
    enabled     = bool
  }))
}
