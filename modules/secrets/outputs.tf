output "db_username" {
  description = "Generated database username"
  value       = random_string.wordpress_db_username.result
  sensitive   = true
}

output "db_password" {
  description = "Generated database password"
  value       = random_password.wordpress_db_password.result
  sensitive   = true
}

output "secret_arn" {
  description = "ARN of the secret containing database credentials"
  value       = aws_secretsmanager_secret.db-secrets.arn
} 