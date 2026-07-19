# url-shortern-deploy

#### The project is try to deploy the github project: https://github.com/ccc-56/URL-shortern
#### I manually deployed it in the aws ap-southeast-1 https://sh.dongzh.store/ for demo        
#### then created those terraform repo, which can be used to create the same environment with only few input change.    


terraform-generated -> used former2 to generate the tf files from aws resource   
terraform-from-scratch -> manually create it first, then with some tools    



step of deploy:     
cd 01-network && terraform init && terraform apply -var-file=terraform-test.tfvars    
                                terraform init -reconfigure -backend-config="key=test/network.tfstate" && terraform apply -var-file=terraform-test.tfvars     
cd ../02-data && terraform init  && terraform apply -var-file=terraform-test.tfvar    
                              terraform init -reconfigure -backend-config="key=test/data.tfstate" && terraform apply -var-file=terraform-test.tfvars    
cd ../03-app  && terraform init && terraform apply -var-file=terraform-test.tfvars    
                              terraform init -reconfigure -backend-config="key=test/app.tfstate"  && terraform apply -var-file=terraform-test.tfvars   
    
    
    
    
     
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

