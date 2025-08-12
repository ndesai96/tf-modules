resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.app_name}-log-group"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      name        = var.app_name
      image       = var.app_image
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
      networkMode = "awsvpc"
      essential   = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      secrets = [
        for name, value in var.app_secrets : {
          name      = name
          valueFrom = value
        }
      ]
      environment = [
        for name, value in var.app_envs : {
          name  = name
          value = value
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.logs.name
          "awslogs-region"        = var.aws_region # Make sure you have var.aws_region defined
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name                          = "${var.app_name}-service"
  cluster                       = aws_ecs_cluster.main.id
  task_definition               = aws_ecs_task_definition.app.arn
  desired_count                 = var.app_count
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = module.alb.target_group_id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [module.alb]
}
