variable "region" {
  description = "AWS region"
  type        = string
}

variable "database_subnets" {
  description = "database subnet"
  type        = list(string)
}

variable "node_private_subnets" {
  description = "node private subnet"
  type        = list(string)
}
