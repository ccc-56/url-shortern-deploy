mock_provider "aws" {}

# The mocked provider returns non-JSON for the policy document, so give the
# IAM assume-role policy a valid JSON value.
override_data {
  target = data.aws_iam_policy_document.ecs_assume
  values = {
    json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

variables {
  cluster_name                  = "url-shortener-cluster"
  region                        = "ap-south-1"
  app_image                     = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/urls/app:latest"
  nginx_image                   = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/urls/nginx:latest"
  redis_host                    = "cache.example.serverless.aps1.cache.amazonaws.com"
  private_subnet_ids            = ["subnet-1", "subnet-2"]
  app_sg_id                     = "sg-app"
  nginx_sg_id                   = "sg-nginx"
  target_group_arn              = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:targetgroup/x/1"
  service_discovery_service_arn = "arn:aws:servicediscovery:ap-south-1:123456789012:service/srv-1"
  tags                          = { Environment = "test" }
}

run "app_task_injects_redis_env" {
  command = plan

  assert {
    condition     = jsondecode(aws_ecs_task_definition.app.container_definitions)[0].name == "app"
    error_message = "App task should define an app container"
  }

  assert {
    condition     = length([for e in jsondecode(aws_ecs_task_definition.app.container_definitions)[0].environment : e if e.name == "REDIS_HOST" && e.value == var.redis_host]) == 1
    error_message = "App container should receive REDIS_HOST from the cache endpoint"
  }

  assert {
    condition     = length([for e in jsondecode(aws_ecs_task_definition.app.container_definitions)[0].environment : e if e.name == "REDIS_PORT" && e.value == "6379"]) == 1
    error_message = "App container should receive REDIS_PORT as a string"
  }
}

run "tasks_are_fargate_awsvpc" {
  command = plan

  assert {
    condition     = aws_ecs_task_definition.app.network_mode == "awsvpc"
    error_message = "Fargate requires awsvpc network mode"
  }

  assert {
    condition     = contains(aws_ecs_task_definition.nginx.requires_compatibilities, "FARGATE")
    error_message = "nginx task should require FARGATE"
  }
}

run "services_wire_lb_and_service_discovery" {
  command = plan

  assert {
    condition     = one(aws_ecs_service.nginx.load_balancer[*].container_name) == "nginx"
    error_message = "nginx service should register the nginx container with the ALB"
  }

  assert {
    condition     = one(aws_ecs_service.app.service_registries[*].registry_arn) == var.service_discovery_service_arn
    error_message = "app service should register with Cloud Map"
  }

  assert {
    condition     = one(aws_ecs_service.app.network_configuration[*].assign_public_ip) == false
    error_message = "app service should run without public IPs"
  }
}
