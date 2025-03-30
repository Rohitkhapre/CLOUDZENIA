resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-wordpress-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.small"  # Appropriate for WordPress in dev/test
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = "wordpress"
  username            = var.db_username
  password            = var.db_password
  
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.db_security_group_id]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  multi_az               = false  # Set to true for production
  skip_final_snapshot    = true   # Set to false for production
  
  tags = {
    Name        = "${var.environment}-wordpress-db"
    Environment = var.environment
  }
} 