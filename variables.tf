variable "identifier" {
  description = "Identifier for DB"
  default     = "teamcity-db"
}

variable "storage_type" {
  description = "Type of the storage ssd or magnetic"
  default     = "gp2"
}

variable "allocated_storage" {
  description = "ammount of storage allocated in GB"
  default     = 10
}

variable "db_engine" {
  description = " DB engine"
  default     = "postgres"
}

variable "engine_version" {
  description = "DB engine version"
  default     = "14.5"
}

variable "instance_class" {
  description = "mashine type to be used"
  default     = "db.m5.large"
}

variable "db_username" {
  description = "db admin user"
  default     = "root"
}

variable "db_password" {
  description = "password, provide through your tfvars file"
}

variable "db_name" {
  description = "database name"
  default     = "teamcitydb"
}

variable "node_private_subnets" {
  default = [
    "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"
  ]
}

variable "database_subnets" {
  default = [
    "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"
  ]
}

variable "region" {
  default = "us-east-2"
}