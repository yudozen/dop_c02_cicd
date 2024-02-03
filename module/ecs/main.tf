# ECSタスク（Terraform）実行用ポリシー
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "ecs_task_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "codebuild:*",
          "codecommit:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_exec_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.id
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_ecs_cluster" "dop_c02_ecs_cluster" {
  name = "dop_c02_ecs_cluster"
}

resource "aws_ecs_task_definition" "dop_c02_ecs_task" {
  family                   = "dop_c02"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
    {
      name      = "dop_c02_terraform"
      image     = "${var.ecr_repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      command   = [
        "version"
      ]
    },
  ])
}

# VPC
resource "aws_vpc" "dop_c02_ecs_vpc" {
  cidr_block = "10.0.0.0/28"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dop_c02"
  }
}

resource "aws_subnet" "dop_c02_ecs_subnet" {
  vpc_id            = aws_vpc.dop_c02_ecs_vpc.id
  cidr_block        = "10.0.0.0/28"  # サブネットの CIDR ブロック

  tags = {
    Name = "dop_c02"
  }
}

# resource "aws_ecs_service" "dop_c02_ecs_service" {
#   name            = "dop_c02_ecs_service"
#   cluster         = aws_ecs_cluster.dop_c02_ecs_cluster.id
#   task_definition = aws_ecs_task_definition.dop_c02_ecs_task.arn
#   desired_count   = 0

#   launch_type = "FARGATE"

#   network_configuration {
#     subnets          = ["subnet-abc123"]
#     security_groups  = ["sg-abc123"]
#     assign_public_ip = true
#   }
# }

# 856679706912.dkr.ecr.us-west-2.amazonaws.com/dop_c02_ecr:latest
