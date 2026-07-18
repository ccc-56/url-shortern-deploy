# url-shortern-deploy

#### this project is try to deploy the github project: https://github.com/ccc-56/URL-shortern
#### I deployed it in the aws ap-southeast-1 https://sh.dongzh.store/ for demo
#### my workflow:
```
deploy the URL-shortern project manually on aws console
    ↓
use former2 to generate the tf files from previous aws resource for reference
    ↓
manually create deployable tf files and test to deploy it in ap-south-1
```

step of deploy:
cd terraform-from-scratch/environments/dev
terraform init -reconfigure
terraform plan  -var-file=./terraform.tfvars
terraform apply  -var-file=./terraform.tfvars

  \
  \
  \
  \
  \
*reference1: the deploy architecture is:*
```
Internet
    ↓
Public ALB
    ↓
Private Nginx in ecs service
    ↓
Private App in ecs service
    ↓
Private redis Valkey
```

*reference2: the shorten url project code arch is:*
```
                 Client
                   |
                   |
              POST /api/shorten
              GET  /r/xxxx
                   |
                   v
              Express App
                app.js
                   |
        +----------+----------+
        |                     |
        v                     v
   Routes                  Middleware
 urlRoutes.js          rateLimiter.js
        |
        |
        v
 Controllers
 urlController.js
        |
        |
        v
 Services
 urlServices.js
        |
        |
        +-------------+
        |             |
        v             v
     Redis        Database
 redisService.js
```

