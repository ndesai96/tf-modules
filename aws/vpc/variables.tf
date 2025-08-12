variable "name" {
  description = "Name of VPC."
  type        = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given region."
  type        = number
  default     = 2
}
