variable "name" {
  description = "app name, used as a prefix for all resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_private_subnet_ids" {
  description = "VPC private subnet ID list"
  type        = list(string)
}

variable "vpc_public_subnet_ids" {
  description = "VPC public subnet ID list"
  type        = list(string)
}

variable "lb_ingress_cidr_blocks" {
  description = "CIDR block list to allow access to LB"
  type        = list(string)
}

variable "sites" {
  description = "map of site names to configuration"

  type = map(object({
    hosts       = list(string)
    source_dir  = string,
    output_path = string,
    runtime     = string
    handler     = string
  }))

  default = {
    site1 = {
      hosts       = ["test1.foo.io"]

      source_dir  = "site1"
      output_path = "files/site1.zip"

      runtime     = "python3.8"
      handler     = "main.lambda_handler"
    }

    site2 = {
      hosts       = ["test2.foo.io"]

      source_dir  = "site2"
      output_path = "files/site2.zip"

      runtime     = "python3.8"
      handler     = "main.lambda_handler"
    }
  }
}
