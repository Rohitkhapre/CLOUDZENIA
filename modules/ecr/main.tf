resource "aws_ecr_repository" "app" {
  name = "${var.environment}-wordpress-app"
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-wordpress-app"
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
} 