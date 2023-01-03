#module "security_groups" {
#  source = "./modules/security_groups"
#  vpc_id = var.vpc_id
#}
resource "random_id" "id" {
  byte_length = 8
}


resource "aws_security_group" "rds_sg" {
  description = "RDS SG"
  name        = "RDS_SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from Database Subnet"
    from_port   = var.database_port
    to_port     = var.database_port
    protocol    = "tcp"
    cidr_blocks = var.node_private_subnets
  }
}

#resource "aws_db_instance" "this" {
#  identifier        = var.identifier
#  db_name           = var.db_name
#  storage_type      = var.storage_type
#  allocated_storage = var.allocated_storage
#  engine            = var.db_engine
#  engine_version    = var.engine_version
#  instance_class    = var.instance_class
#  username          = var.db_username
#  password          = var.db_password
#
#  vpc_security_group_ids = [
#    aws_security_group.rds_sg.id,
#  ]
#
#  db_subnet_group_name                = var.db_subnet_group_name
#  storage_encrypted                   = false
#  skip_final_snapshot                 = true
#  publicly_accessible                 = false
#  multi_az                            = false
#  iam_database_authentication_enabled = true
#
#  tags = {
#    Name = "teamcity"
#  }
#}

resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-pass-${random_id.id.hex}"
}

resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id     = aws_secretsmanager_secret.db-pass.id
  secret_string = jsonencode(
    {
      username = var.db_master_username
      password = var.db_master_password
      engine   = "mysql"
      host     = aws_rds_cluster.cluster.endpoint
    })
}

resource "aws_rds_cluster" "cluster" {
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.08.3"
  engine_mode          = "serverless"
  database_name        = var.database_name
  master_username      = var.db_master_username
  master_password      = var.db_master_password
  port                 = var.database_port
  enable_http_endpoint = true
  skip_final_snapshot  = true
  scaling_configuration {
    min_capacity = 1
  }

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id,
  ]

  db_subnet_group_name = var.db_subnet_group_name

  tags = {
    Name = "teamcity"
  }
}

resource "null_resource" "db_setup" {
  triggers = {
    file = filesha1("rds/sql/initial.sql")
  }
  provisioner "local-exec" {
    command     = <<-EOF
			while read line; do
				echo "$line"
				aws rds-data execute-statement --resource-arn "$DB_ARN" --database  "$DB_NAME" --secret-arn "$SECRET_ARN" --sql "$line"
			done  < <(awk 'BEGIN{RS=";\n"}{gsub(/\n/,""); if(NF>0) {print $0";"}}' rds/sql/initial.sql | sed "s/<database-name>/${aws_rds_cluster.cluster.database_name}/g;s/<user-name>/${var.db_username}/g;s/<password>/${var.db_password}/g")
			EOF
    environment = {
      DB_ARN     = aws_rds_cluster.cluster.arn
      DB_NAME    = aws_rds_cluster.cluster.database_name
      SECRET_ARN = aws_secretsmanager_secret.db-pass.arn
    }
    interpreter = ["bash", "-c"]

  }
}

#resource "aws_iam_role_policy_attachment" "test-attach" {
#  role       = "node-group-1-eks-node-group-20221223201052613000000009"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#}