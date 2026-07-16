# url-shortern-deploy

#### this project is try to deploy the github project: https://github.com/05sanjaykumar/URL-shortern
#### I deployed it in the aws ap-southeast-1 https://sh.dongzh.store/
#### my idea, deploy the URL-shortern project manually on aws console  ->  use former2 to generate the tf files from previous aws resource  ->  manually create deployable tf files


#### the deploy architecture is:
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

#### the shorten url project code arch is:
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

