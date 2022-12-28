#data "terraform_remote_state" "eks" {
#  backend = "local"
#
#  config = {
#    path = "./terraform.tfstate"
#  }
#}

terraform {
  backend "s3" {
    bucket = "teamcity-state-bucket"
    key    = "tfstate"
    region = "us-east-2"
  }
}