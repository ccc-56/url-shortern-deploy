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

`test` deploys to `ap-northeast-1` (set in `terraform-test.tfvars`) with its own
VPC CIDR (`10.75.0.0/16`), its own ECR repos
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

`region`, `azs`, and the CIDRs all live in `terraform-test.tfvars` — edit them
there to target another region. The remote-state bucket region is separate
(`state_region`, defaults to `ap-south-1` where the state bucket lives), so state
stays in the existing bucket regardless of deploy region. If you want a second
region to coexist with this one, give each layer its own state key at `init`
(`-backend-config="key=..."`) so it doesn't overwrite the default `test/*` state,
and set the matching `network_state_key`/`data_state_key` for the upper layers.

## Prerequisites before `03-app` works end to end

1. Push app/nginx images to the `urls-test/*` ECR repos (created by `03-app`).
2. The nginx image must use `resolver 10.75.0.2` (the `test` VPC DNS, i.e. VPC
   base `+2`) — the resolver is baked into the image, not Terraform.
