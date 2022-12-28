variable vpc_id {}

variable region {}

variable db_subnet_group_name {}

variable "identifier" {}

variable "storage_type" {}

variable "allocated_storage" {}

variable "db_engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "db_username" {}

variable "db_password" {}

variable "db_name" {}

variable node_private_subnets {
  type = list(string)
}