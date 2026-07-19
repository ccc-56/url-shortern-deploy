# URL Shortener — Terraform (ap-south-1)

Terraform that reproduces the manually-built ap-southeast-1 stack (captured in
`../terraform-generated/main.tf`) in **ap-south-1**.

## Architecture

```
Internet
   ↓
Public ALB            (public subnets, alb-sg: 80/443 from 0.0.0.0/0)
   ↓  HTTP :80
Nginx  (ECS Fargate)  (private subnets, nginx-sg: 80 from alb-sg)
   ↓  :3000 via Cloud Map (shortname-app.shortname.internal)
App    (ECS Fargate)  (private subnets, app-sg: 3000 from nginx-sg)
   ↓  :6379 (TLS, rediss://)
ElastiCache Serverless (Valkey)  (private subnets, redis-sg: 6379 from app-sg)
```

Private subnets reach the internet (ECR pulls, etc.) via a NAT gateway.

## Modules

| Module | Purpose |
|--------|---------|
| `network` | VPC + public/private subnets |
| `internet-gateway` | IGW + public route table |
| `nat-gateway` | EIP + NAT gateway + private route table |
| `security-groups` | alb / nginx / app / redis security groups |
| `ecr` | `urls/app` and `urls/nginx` repositories |
| `alb` | ALB + IP target group + HTTP (optional HTTPS) listener |
| `service-discovery` | Cloud Map private DNS namespace + app service |
| `elasticache` | Serverless Valkey/Redis cache (TLS) |
| `ecs` | Cluster, execution IAM role, log groups, task defs, services |

## Deploy

```
# 0. one-time: create the S3 state bucket (see step0.backend/)
cd step0.backend && terraform init && terraform apply

# 1. main stack
cd ../environments/dev
terraform init -reconfigure
terraform plan  -var-file=./terraform.tfvars
terraform apply -var-file=./terraform.tfvars
```

## Prerequisites before `apply` succeeds end-to-end

1. **AWS credentials** with permissions for VPC, ECS, ELB, ECR, ElastiCache,
   Cloud Map, IAM, CloudWatch Logs.
2. **Container images pushed to ECR.** `terraform apply` creates the ECR repos,
   but the ECS services stay unhealthy until images exist at
   `urls/app:latest` and `urls/nginx:latest`. Build from the app repo
   (`ccc-56/URL-shortern`) and push, e.g.:
   ```
   aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <acct>.dkr.ecr.ap-south-1.amazonaws.com
   docker build -f Dockerfile-app   -t <acct>.dkr.ecr.ap-south-1.amazonaws.com/urls/app:latest .
   docker build -f Dockerfile-nginx -t <acct>.dkr.ecr.ap-south-1.amazonaws.com/urls/nginx:latest .
   docker push <acct>.dkr.ecr.ap-south-1.amazonaws.com/urls/app:latest
   docker push <acct>.dkr.ecr.ap-south-1.amazonaws.com/urls/nginx:latest
   ```
3. **Rebuild the nginx image for this VPC.** `nginx/default.conf` in the app
   repo hardcodes `resolver 10.68.0.2` (the ap-southeast-1 VPC DNS) and the
   upstream `shortname-app.shortname.internal`. For the `10.61.0.0/16` VPC here
   the resolver must be **`10.61.0.2`** (VPC CIDR base + 2). Keep the Cloud Map
   names (`service_namespace` / `app_service_name`) matching the nginx upstream,
   or override those variables to match your image.
4. **HTTPS (optional).** Set `certificate_arn` to an ACM cert (e.g. for
   `*.dongzh.store`) to add a 443 listener, then point your DNS CNAME at the
   `alb_dns_name` output.

## Tests

Native `terraform test` runs (mocked provider, `command = plan`, no AWS creds):

```
for m in network internet-gateway nat-gateway security-groups ecr alb service-discovery ecs; do
  (cd modules/$m && terraform init -backend=false && terraform test)
done
```
