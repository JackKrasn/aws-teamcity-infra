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
  description = "db user for teamcitydb"
  default     = "teamcity"
}

variable "db_master_password" {
  description = "db master password, provide through your tfvars file"
}

variable "db_password" {
  description = "teamcity db user password, provide through your tfvars file"
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
  description = "AWS region"
  default = "eu-west-2"
}

variable "access_key_id" {
  description = "password, provide through your tfvars file"
}

variable "secret_access_key" {
  description = "password, provide through your tfvars file"
}

variable "deploy_teamcity" {
  default = true
}