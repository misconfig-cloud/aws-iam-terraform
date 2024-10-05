variable "external_id" {
  description = "External ID used to secure role assumptions"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role to be created"
  type        = string
  default     = "misconfig-cloud-role"
}