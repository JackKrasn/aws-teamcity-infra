variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "database_subnets" {
  description = "database subnet"
  type        = list(string)
}

variable "node_private_subnets" {
  description = "node private subnet"
  type        = list(string)
}
