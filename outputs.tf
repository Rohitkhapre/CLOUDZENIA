output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.ecs.alb_dns_name
}

output "certificate_validation_details" {
  description = "Details needed for certificate validation in Namecheap"
  value = module.ecs.certificate_validation_details
} 