# `test` environment (layered remote state)

Unlike `dev` (a single root module / single state file), the `test` environment is
split into independent layers, each with its **own S3 state key and lock**. Lower
layers publish outputs that upper layers consume through `terraform_remote_state`.

| Layer | Dir | State key | Contains |
|-------|-----|-----------|----------|
| Network | `01-network` | `test/network.tfstate` | VPC, subnets, IGW, NAT, security groups |
| Data | `02-data` | `test/data.tfstate` | ElastiCache Serverless (Valkey) |
| App | `03-app` | `test/app.tfstate` | ECR, ALB, Cloud Map, ECS cluster + services |

All layers share the existing backend bucket `shortn1-terraform-state-bucket`
(region `ap-south-1`) and lock table `terraform-lock-dev`.

## Why layers

- Smaller blast radius: an app change can't accidentally destroy the VPC or cache.
- Independent, faster plans/applies per layer.
- Per-layer access control is possible (different state keys).

## Isolation from `dev`

`test` uses its own VPC CIDR (`10.62.0.0/16`), its own ECR repos
(`urls-test/app`, `urls-test/nginx`), and its own ECS cluster
(`url-shortener-test-cluster`), so it never collides with the `dev` stack in the
same account/region.

## Apply order (bottom-up)

Each layer's variables live in `terraform-test.tfvars`. It is **not** auto-loaded
(only `terraform.tfvars`/`*.auto.tfvars` are), so pass it explicitly:

```bash
cd 01-network && terraform init && terraform apply -var-file=terraform-test.tfvars
cd ../02-data && terraform init && terraform apply -var-file=terraform-test.tfvars
cd ../03-app && terraform init && terraform apply -var-file=terraform-test.tfvars
```

Destroy in reverse order (`03-app` → `02-data` → `01-network`).

## Deploying to a different region

Everything is overridable from the CLI — `-var` beats `terraform.tfvars`. The
remote-state bucket region is decoupled from the deploy region via `state_region`
(defaults to `ap-south-1`, where the state bucket lives), so you can deploy to any
region while keeping state in the existing bucket. Give each layer its own state
key with `-backend-config` so it doesn't overwrite the default `test/*` state.

Example — deploy to `ap-northeast-1` with CIDR `10.74.0.0/16`:

```bash
# 1) NETWORK
cd 01-network
terraform init -reconfigure -backend-config="key=test-apne1/network.tfstate"
terraform apply \
  -var="region=ap-northeast-1" \
  -var="vpc_cidr=10.74.0.0/16" \
  -var='azs=["ap-northeast-1a","ap-northeast-1c"]' \
  -var='public_subnet_cidrs=["10.74.10.0/24","10.74.20.0/24"]' \
  -var='private_subnet_cidrs=["10.74.11.0/24","10.74.21.0/24"]'

# 2) DATA
cd ../02-data
terraform init -reconfigure -backend-config="key=test-apne1/data.tfstate"
terraform apply \
  -var="region=ap-northeast-1" \
  -var="network_state_key=test-apne1/network.tfstate"

# 3) APP
cd ../03-app
terraform init -reconfigure -backend-config="key=test-apne1/app.tfstate"
terraform apply \
  -var="region=ap-northeast-1" \
  -var="network_state_key=test-apne1/network.tfstate" \
  -var="data_state_key=test-apne1/data.tfstate"
```

For that region the nginx image must be built with `resolver 10.74.0.2` (VPC base
`+2`). ECR repos (`urls-test/*`) are per-region, so they don't clash with other
regions' repos.

## Prerequisites before `03-app` works end to end

1. Push app/nginx images to the `urls-test/*` ECR repos (created by `03-app`).
2. The nginx image must use `resolver 10.62.0.2` (the `test` VPC DNS, i.e. VPC
   base `+2`) — the resolver is baked into the image, not Terraform.
