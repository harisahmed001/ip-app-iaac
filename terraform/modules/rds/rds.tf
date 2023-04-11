
resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 10
  identifier             = "${var.name}-tf-rds"
  db_name                = var.name
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  username               = var.name
  password               = var.password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.aws_db_subnet_group_rds.id
  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "aws_db_subnet_group_rds" {
  name        = "${var.name}-tf-rds-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "${var.name}-tf-rds-subnet-group"
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-tf-rds"
  description = "Allow all ports, just for testing"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Traffic from ec2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.source_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.name}-tf-vpc-all-allowed-sg"
  }
}
