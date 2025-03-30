resource "random_string" "wordpress_db_username" {
  length  = 10
  special = false

  lifecycle {
    ignore_changes = all
  }
}

resource "random_password" "wordpress_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_secretsmanager_secret" "db-secrets" {
  name = "${var.environment}-wordpress-db-credentials"
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db-secrets" {
  secret_id = aws_secretsmanager_secret.db-secrets.id
  secret_string = jsonencode({
    username = random_string.wordpress_db_username.result
    password = random_password.wordpress_db_password.result
    dbname   = var.db_name
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
} 