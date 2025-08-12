variable "ami_id" {
  description = "The ID of the AMI to use for the instance."
  type        = string
  default     = "ami-020cba7c55df1f615" # Ubuntu Server 24.04 LTS
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
}
