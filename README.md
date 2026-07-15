# url-shortern-deploy

#### this project is deploy the github project: https://github.com/05sanjaykumar/URL-shortern on aws

#### the deploy architecture is:
```
Internet
    ↓
Public ALB
    ↓
Private Nginx
    ↓
Private App
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

