variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "Name of the database subnet group"
  type        = string
}

variable "db_security_group_id" {
  description = "ID of the database security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
} 