#module "security_groups" {
#  source = "./modules/security_groups"
#  vpc_id = var.vpc_id
#}

resource "aws_security_group" "rds_sg" {
  description = "RDS SG"
  name        = "RDS_SG"
  vpc_id      = var.vpc_id

  ingress {
    description      = "PostgreSQL from Database Subnet"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = var.node_private_subnets
  }
}

#resource "aws_security_group" "pod_sg" {
#  description = "POD SG"
#  name        = "POD_SG"
#  vpc_id      = var.vpc_id
#}

# RDS_SG=sg-092ef6307c635cbb4
# POD_SG=sg-0ccfaab5358167197
# cerate groupId rule sg-092ef6307c635cbb4
#resource "aws_security_group_rule" "allow_access_to_db" {
#  description              = "Allow access to database"
#  type                     = "ingress"
#  from_port                = 5432
#  to_port                  = 5432
#  protocol                 = "tcp"
#  security_group_id        = aws_security_group.rds_sg.id
#  source_security_group_id = aws_security_group.pod_sg.id
#}

#resource "aws_db_instance" "rds_instance" {
#  allocated_storage                   = 5
#  max_allocated_storage               = 10
#  db_name                             = "teamcitydb"
#  engine                              = "postgres"
#  engine_version                      = "14.3"
#  instance_class                      = "db.m5.large"
#  username                            = "teamcity"
#  password                            = "teamcity"
#  port                                = 5432
#  skip_final_snapshot                 = true
#  iam_database_authentication_enabled = true
#  db_subnet_group_name                = data.terraform_remote_state.eks.outputs.database_subnet_group_name
#  tags                                = local.tags
#  vpc_security_group_ids              = [module.security_groups.rds_sg_id]
#}

resource "aws_db_instance" "this" {
  identifier        = var.identifier
  db_name           = var.db_name
  storage_type      = var.storage_type
  allocated_storage = var.allocated_storage
  engine            = var.db_engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id,
  ]

  db_subnet_group_name                = var.db_subnet_group_name
  storage_encrypted                   = false
  skip_final_snapshot                 = true
  publicly_accessible                 = false
  multi_az                            = false
  iam_database_authentication_enabled = true

  tags = {
    Name = "teamcity"
  }
}

#resource "aws_iam_role_policy_attachment" "test-attach" {
#  role       = "node-group-1-eks-node-group-20221223201052613000000009"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#}