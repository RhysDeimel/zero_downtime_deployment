variable "vpc_id" {
  type        = string
  description = "ID of your VPC"

  validation {
    condition     = can(regex("^(vpc-)([a-z0-9]{8}|[a-z0-9]{17})$", var.vpc_id))
    error_message = "VPC ID does not seem to be correct"
  }
}


variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnets in which to create your ASG instances"

  validation {
    condition = alltrue([
      for s in var.private_subnet_ids : can(regex("^(subnet-)([a-z0-9]{8}|[a-z0-9]{17})$", s))
    ])
    error_message = "One or more of the subnets is incorrect"
  }
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of public subnets in which to create your load balancer"

  validation {
    condition = alltrue([
      for s in var.public_subnet_ids : can(regex("^(subnet-)([a-z0-9]{8}|[a-z0-9]{17})$", s))
    ])
    error_message = "One or more of the subnets is incorrect"
  }
}


variable "foo_version" {
  type        = number
  description = "A dummy version number of your choosing"
}
