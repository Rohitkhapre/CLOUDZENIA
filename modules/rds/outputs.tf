output "endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.wordpress.endpoint
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.wordpress.arn
} 