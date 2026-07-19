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

## Per-environment tfvars

Each layer has one tfvars file **per deployment target**, named
`terraform-<env>.tfvars`:

| Env | Region | VPC CIDR | State-key prefix |
|-----|--------|----------|------------------|
| `aps1` | `ap-south-1` | `10.62.0.0/16` | `test/` |
| `apne1` | `ap-northeast-1` | `10.74.0.0/16` | `test-apne1/` |

These are **not** auto-loaded (only `terraform.tfvars`/`*.auto.tfvars` are), so
you must pass `-var-file=terraform-<env>.tfvars` on every `apply`/`plan`. They
contain everything variable — including `region`, CIDRs, AZs, and the
`network_state_key`/`data_state_key` each layer reads. The only thing that can't
live in a tfvars file is the layer's own backend **state key**, which must be set
at `init` time with `-backend-config="key=..."` (backend config isn't
variable-driven). To add a new environment, copy a pair of files and adjust.

## Why layers

- Smaller blast radius: an app change can't accidentally destroy the VPC or cache.
- Independent, faster plans/applies per layer.
- Per-layer access control is possible (different state keys).

## Isolation from `dev`

`test` uses its own VPC CIDR (`10.62.0.0/16`), its own ECR repos
(`urls-test/app`, `urls-test/nginx`), and its own ECS cluster
(`url-shortener-test-cluster`), so it never collides with the `dev` stack in the
same account/region.

## Apply

Pick an env (`aps1` or `apne1`), pass its `-var-file`, and set each layer's own
state key at `init` with `-backend-config`. Apply bottom-up.

Example — `apne1` (ap-northeast-1, `10.74.0.0/16`):

```bash
# 1) NETWORK
cd 01-network
terraform init -reconfigure -backend-config="key=test-apne1/network.tfstate"
terraform apply -var-file=terraform-apne1.tfvars

# 2) DATA
cd ../02-data
terraform init -reconfigure -backend-config="key=test-apne1/data.tfstate"
terraform apply -var-file=terraform-apne1.tfvars

# 3) APP
cd ../03-app
terraform init -reconfigure -backend-config="key=test-apne1/app.tfstate"
terraform apply -var-file=terraform-apne1.tfvars
```

For `aps1`, swap the `-var-file` to `terraform-aps1.tfvars` and the init keys to
`test/network.tfstate`, `test/data.tfstate`, `test/app.tfstate`.

Destroy in reverse order (`03-app` → `02-data` → `01-network`) with the same
`-var-file` and init keys.

## Prerequisites before `03-app` works end to end

1. Push app/nginx images to the `urls-test/*` ECR repos (created by `03-app`).
2. The nginx image must use the target VPC's resolver (VPC base `+2`):
   `10.62.0.2` for `aps1`, `10.74.0.2` for `apne1` — the resolver is baked into
   the image, not Terraform.
