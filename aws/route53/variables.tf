variable "alias_name" {
  description = "The name of the alias."
  type        = string
}

variable "alias_zone_id" {
  description = "The Route53 zone ID of the alias."
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone where the record will be created."
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the Route 53 Hosted Zone."
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the A record."
  type        = string
}
