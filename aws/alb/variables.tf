variable "app_name" {
  description = "Name of ECS cluster."
  type        = string

  validation {
    condition     = length(var.app_name) <= 26
    error_message = "Name must be 26 characters or less."
  }
}

variable "app_port" {
  description = "Port exposed by the Docker image to redirect traffic to."
  type        = number
}

variable "app_protocol" {
  description = "Protocol to use for routing traffic to the Docker container."
  type        = string
  default     = "HTTP"
}

variable "app_protocol_version" {
  description = "Protocol version used to send requests to the Docker container."
  type        = string
  default     = "HTTP1"
}

variable "ca_cert" {
  description = "The CA cert used for client authentication when mTLS is enabled."
  type        = string
  default     = ""

  validation {
    condition     = var.enable_mtls == false || (var.enable_mtls == true && var.ca_cert != "" && can(fileexists(var.ca_cert)))
    error_message = "When 'enable_mtls' is true, a valid file path for 'ca_cert' must be provided."
  }
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate to use for HTTPS."
  type        = string
}

variable "enable_mtls" {
  description = "Enables mTLS authentication."
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = "IDs of public subnets for the ECS service."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC where the ECS cluster should be provisioned."
  type        = string
}
