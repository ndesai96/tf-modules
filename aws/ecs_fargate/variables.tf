variable "app_count" {
  description = "Number of tasks to run."
  type        = number
  default     = 3
}

variable "app_min_count" {
  description = "The minimum number of tasks for the ECS service."
  type        = number
  default     = 1
}

variable "app_max_count" {
  description = "The maximum number of tasks for the ECS service."
  type        = number
  default     = 5
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster."
  type        = string
}

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
  description = "Protocol to use for routing traffic to the Docker image."
  type        = string
  default     = "HTTP"
}

variable "app_protocol_version" {
  description = "Protocol version used to send requests to the Docker container."
  type        = string
  default     = "HTTP1"
}

variable "app_secrets" {
  description = "A map of secrets to pass to the container. The keys are the environment variable names and the values are the ARNs of the secrets in AWS Secrets Manager."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region things are created in."
  type        = string
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

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)."
  type        = number
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)."
  type        = number
  default     = 2048
}

variable "enable_mtls" {
  description = "Enables mTLS authentication in the ALB."
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "IDs of private subnets for the ECS service."
  type        = list(string)
}

variable "public_subnets" {
  description = "IDs of public subnets for the ECS service."
  type        = list(string)
}

variable "scale_in_cpu_threshold" {
  description = "The target CPU utilization percentage to trigger a scale-in event."
  type        = number
  default     = 50 # Scale in when CPU utilization goes below 50%
}

variable "scale_out_cpu_threshold" {
  description = "The target CPU utilization percentage to trigger a scale-out event."
  type        = number
  default     = 70 # Scale out when CPU utilization goes above 70%
}

variable "vpc_id" {
  description = "VPC where the ECS cluster should be provisioned."
  type        = string
}
