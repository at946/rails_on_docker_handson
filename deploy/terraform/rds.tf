##############################
# Security Group for RDS
##############################
resource "aws_security_group" "rds" {
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  tags = {
    Name = "sg-${var.project}-rds"
  }
}

##############################
# DB Subnet for RDS
##############################
resource "aws_db_subnet_group" "default" {
  name  = "${var.project}-db-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

##############################
# RDS
##############################
resource "aws_db_instance" "rds" {
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.default.name
  engine                  = "postgres"
  engine_version          = "12.2"
  instance_class          = "db.t2.micro"
  username                = "handson_user"
  password                = "handson2020"
  port                    = 5432
  vpc_security_group_ids  = [aws_security_group.rds.id]
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project}-db"
  }
}