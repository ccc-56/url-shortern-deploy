mock_provider "aws" {}

run "creates_one_repo_per_name" {
  command = plan

  variables {
    repository_names = ["urls/app", "urls/nginx"]
    tags             = { Environment = "test" }
  }

  assert {
    condition     = length(aws_ecr_repository.this) == 2
    error_message = "One ECR repository should be created per name"
  }

  assert {
    condition     = aws_ecr_repository.this["urls/app"].name == "urls/app"
    error_message = "Repository should be keyed and named by the input name"
  }

  assert {
    condition     = aws_ecr_repository.this["urls/nginx"].image_scanning_configuration[0].scan_on_push == true
    error_message = "Scan on push should default to true"
  }
}
