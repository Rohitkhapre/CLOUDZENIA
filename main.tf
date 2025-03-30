provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = [var.public_subnet_1_cidr, var.public_subnet_2_cidr]
  private_subnet_cidrs = [var.private_subnet_1_cidr, var.private_subnet_2_cidr]
  availability_zones   = [var.availability_zone_1, var.availability_zone_2]
}

module "secrets" {
  source = "./modules/secrets"

  environment = var.environment
  db_name     = var.db_name
}

module "security" {
  source = "./modules/security"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "rds" {
  source = "./modules/rds"

  environment          = var.environment
  vpc_id               = module.networking.vpc_id
  db_subnet_group_name = module.networking.db_subnet_group_name
  db_security_group_id = module.security.rds_security_group_id
  db_username          = module.secrets.db_username
  db_password          = module.secrets.db_password
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
}

module "ecs" {
  source = "./modules/ecs"

  environment         = var.environment
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  alb_security_group_id = module.security.alb_security_group_id
  ecr_repository_url    = module.ecr.repository_url
  db_secret_arn         = module.secrets.secret_arn
  rds_endpoint          = module.rds.endpoint
  aws_region            = var.aws_region
  execution_role_arn    = aws_iam_role.ecs_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  domain_name           = var.domain_name

  depends_on = [
    module.networking,
    module.rds
  ]
}

# IAM roles for ECS
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Add policy to allow ECS tasks to access Secrets Manager
resource "aws_iam_role_policy" "ecs_task_secrets_policy" {
  name = "${var.environment}-ecs-task-secrets-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [module.secrets.secret_arn]
      }
    ]
  })
} 