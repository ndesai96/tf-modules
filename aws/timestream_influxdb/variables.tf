variable "admin_access_cidr" {
  description = "CIDR block for admin access to the Timestream InfluxDB instance."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_admin_access || (var.admin_access_cidr != null && var.admin_access_cidr != "")
    error_message = "The 'admin_access_cidr' variable must be set when 'enable_admin_access' is true."
  }
}

variable "allocated_storage" {
  description = "The allocated storage in GB for the Timestream InfluxDB instance."
  type        = number
  default     = 20
}

variable "bucket" {
  description = "The name of the InfluxDB bucket to create within the Timestream InfluxDB instance."
  type        = string
}

variable "db_instance_type" {
  description = "The instance type for the Timestream InfluxDB instance (e.g., db.influx.medium)."
  type        = string
  default     = "db.influx.medium"
}

variable "enable_admin_access" {
  description = "Whether to enable direct admin access to the Timestream InfluxDB instance from a specific CIDR block."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the Timestream InfluxDB instance, also used for naming related resources."
  type        = string
}

variable "organization" {
  description = "The name of the InfluxDB organization to create within the Timestream InfluxDB instance."
  type        = string
}

variable "password" {
  description = "The password for the primary admin user of the Timestream InfluxDB instance."
  type        = string
  sensitive   = true
}

variable "publicly_accessible" {
  description = "Whether the Timestream InfluxDB instance should be publicly accessible."
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs where the Timestream InfluxDB instance will be deployed."
  type        = list(string)
}

variable "username" {
  description = "The username for the primary admin user of the Timestream InfluxDB instance."
  type        = string
  default     = "admin"
}

variable "vpc_id" {
  description = "The ID of the VPC where the Timestream InfluxDB instance and its security group will be created."
  type        = string
}
