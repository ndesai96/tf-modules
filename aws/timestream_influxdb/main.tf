resource "aws_timestreaminfluxdb_db_instance" "db" {
  allocated_storage      = var.allocated_storage
  bucket                 = var.bucket
  db_instance_type       = var.db_instance_type
  name                   = var.name
  username               = var.username
  password               = var.password
  organization           = var.organization
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = var.publicly_accessible
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Allow access to Timestream InfluxDB instance ${var.name}"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_admin" {
  count = var.enable_admin_access ? 1 : 0

  description       = "Allow admin access to Timestream InfluxDB instance ${var.name}"
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = var.admin_access_cidr
  ip_protocol       = "tcp"
  from_port         = 8086
  to_port           = 8086
}

