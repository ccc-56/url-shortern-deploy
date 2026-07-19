# url-shortern-deploy

#### The project is try to deploy the github project: https://github.com/ccc-56/URL-shortern
#### I manully deployed it in the aws ap-southeast-1 https://sh.dongzh.store/ for demo        
#### then created those terraform repo, which can be used to create the same environment with only few input change.    


terraform-generated -> used former2 to generate the tf files from aws resource   
terraform-from-scratch -> manully create it first, then with some tools    




```

step of deploy:  \
cd terraform-from-scratch/environments/dev  \
terraform init -reconfigure  \
terraform plan  -var-file=./terraform.tfvars  \
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

