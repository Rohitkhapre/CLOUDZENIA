output "endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.main.arn
} 