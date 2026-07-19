terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

# CIDR allowed to reach administrative ports (e.g. SSH). Defaults to the VPC
# range so nothing is exposed to the public internet. Override with a trusted
# office/VPN CIDR if remote admin access is required.
variable "ssh_ingress_cidr" {
    type    = string
    default = "10.68.0.0/16"
}

resource "aws_vpc" "EC2VPC" {
    cidr_block = "10.68.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = {
        Name = "shortname"
    }
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.elasticache.serverless.ap-southeast-1.vpce-svc-0aae5e457931d408b"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::787987774269:root"
      },
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-029e611cbe5f5a785",
        "subnet-0b21090d0f7b46aa9"
    ]
    private_dns_enabled = false
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup3.id}",
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint2" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.elasticache.serverless.ap-southeast-1.vpce-svc-0b7fd5d5f3c4e7c89"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::787987774269:root"
      },
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-029e611cbe5f5a785",
        "subnet-0b21090d0f7b46aa9"
    ]
    private_dns_enabled = false
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup3.id}",
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint3" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.elasticache.serverless.ap-southeast-1.vpce-svc-0e43bbb82ac685862"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::787987774269:root"
      },
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-029e611cbe5f5a785",
        "subnet-0b21090d0f7b46aa9"
    ]
    private_dns_enabled = false
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup3.id}",
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "allow short ecs1"
    name = "short-ecs-sg1"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup7.id}"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        security_groups = [
            "sg-09915fed9f49b5af2"
        ]
        from_port = 6379
        protocol = "tcp"
        to_port = 6379
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup4.id}"
        ]
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup7.id}"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup2" {
    description = "redis-sg"
    name = "redis-sg"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        from_port = 6379
        protocol = "tcp"
        to_port = 6379
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup3" {
    description = "Security group attached to shortnamen12 to allow CloudShell to connect to the database. Modification could lead to connection loss."
    name = "cloudshell-elasticache-shortnamen12"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup8.id}"
        ]
        from_port = 6379
        protocol = "tcp"
        to_port = 6379
    }
}

resource "aws_security_group" "EC2SecurityGroup4" {
    description = "nginx sg"
    name = "nginx-sg"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup7.id}"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup7.id}"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup5" {
    description = "launch-wizard-1 created 2026-07-12T09:33:02.104Z"
    name = "launch-wizard-1"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        cidr_blocks = [
            var.ssh_ingress_cidr
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup6" {
    description = "app sg"
    name = "app sg"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup4.id}"
        ]
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup7" {
    description = "allow 80 traffic"
    name = "short-alb-sg1"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup8" {
    description = "Security group for CloudShell to securely connect to shortnamen12. Modification could lead to connection loss."
    name = "elasticache-cloudshell-shortnamen12"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    egress {
        security_groups = [
            "sg-014b2bfd5daa1b895"
        ]
        from_port = 6379
        protocol = "tcp"
        to_port = 6379
    }
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
    health_check {
        interval = 30
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200"
    }
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    name = "nginx-target"
}

resource "aws_subnet" "EC2Subnet" {
    availability_zone = "ap-southeast-1b"
    cidr_block = "10.68.21.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet2" {
    availability_zone = "ap-southeast-1a"
    cidr_block = "10.68.10.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet3" {
    availability_zone = "ap-southeast-1a"
    cidr_block = "10.68.11.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet4" {
    availability_zone = "ap-southeast-1b"
    cidr_block = "10.68.20.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
    name = "alb-tonginx"
    internal = false
    load_balancer_type = "application"
    subnets = [
        "subnet-0531ae96697dfba18",
        "subnet-0e2ff8df742e86191"
    ]
    security_groups = [
        "${aws_security_group.EC2SecurityGroup7.id}"
    ]
    ip_address_type = "ipv4"
    access_logs {
        enabled = true
        bucket = "alb-tonginx-log-20260713"
        prefix = ""
    }
    idle_timeout = "60"
    enable_deletion_protection = "false"
    enable_http2 = "true"
    enable_cross_zone_load_balancing = "true"
}

resource "aws_ecs_cluster" "ECSCluster" {
    name = "url-shortener-cluster"
}

resource "aws_internet_gateway" "EC2InternetGateway" {
    tags = {
        Name = "my-igw2"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
}

resource "aws_route" "EC2Route" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0a04f75d65315c446"
    route_table_id = "rtb-0378199ef1ff7761e"
}

resource "aws_nat_gateway" "EC2NatGateway" {
    tags = {
        Name = "my-shortname-nat1"
    }
}

resource "aws_route" "EC2Route2" {
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "nat-1653e47fd8ea9b66f"
    route_table_id = "rtb-0033ba759b072c442"
}

resource "aws_route_table" "EC2RouteTable" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "my-private-01"
    }
}

resource "aws_route_table" "EC2RouteTable2" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "my-pub-02"
    }
}

resource "aws_route_table" "EC2RouteTable3" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "my-private-02"
    }
}

resource "aws_route_table" "EC2RouteTable4" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {}
}

resource "aws_route_table" "EC2RouteTable5" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {}
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation" {
    route_table_id = "rtb-0033ba759b072c442"
    subnet_id = "subnet-0b21090d0f7b46aa9"
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation2" {
    route_table_id = "rtb-0378199ef1ff7761e"
    subnet_id = "subnet-0e2ff8df742e86191"
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation3" {
    route_table_id = "rtb-01965a50b6864cd82"
    subnet_id = "subnet-029e611cbe5f5a785"
}

resource "aws_ecs_service" "ECSService" {
    name = "shortname-nginx-service-72yugpts"
    cluster = "arn:aws:ecs:ap-southeast-1:787987774269:cluster/url-shortener-cluster"
    load_balancer {
        target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:787987774269:targetgroup/nginx-target/a9063954294d42d7"
        container_name = "nginx"
        container_port = 80
    }
    desired_count = 1
    launch_type = "FARGATE"
    platform_version = "LATEST"
    task_definition = "${aws_ecs_task_definition.ECSTaskDefinition2.arn}"
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    iam_role = "arn:aws:iam::787987774269:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
    network_configuration {
        assign_public_ip = "DISABLED"
        security_groups = [
            "${aws_security_group.EC2SecurityGroup4.id}"
        ]
        subnets = [
            "subnet-029e611cbe5f5a785",
            "subnet-0b21090d0f7b46aa9"
        ]
    }
    health_check_grace_period_seconds = 0
    scheduling_strategy = "REPLICA"
}

resource "aws_ecs_service" "ECSService2" {
    name = "url-shortener-task-service-08owoxfy"
    cluster = "arn:aws:ecs:ap-southeast-1:787987774269:cluster/url-shortener-cluster"
    service_registries {
        registry_arn = "arn:aws:servicediscovery:ap-southeast-1:787987774269:service/srv-rrldzgsfaioo5ujk"
    }
    desired_count = 1
    platform_version = "1.4.0"
    task_definition = "${aws_ecs_task_definition.ECSTaskDefinition.arn}"
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    iam_role = "arn:aws:iam::787987774269:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
    network_configuration {
        assign_public_ip = "DISABLED"
        security_groups = [
            "${aws_security_group.EC2SecurityGroup.id}"
        ]
        subnets = [
            "subnet-029e611cbe5f5a785",
            "subnet-0b21090d0f7b46aa9"
        ]
    }
    health_check_grace_period_seconds = 0
    scheduling_strategy = "REPLICA"
}

resource "aws_ecs_task_definition" "ECSTaskDefinition" {
    container_definitions = "[{\"name\":\"app\",\"image\":\"787987774269.dkr.ecr.ap-southeast-1.amazonaws.com/urls/app:latest\",\"cpu\":0,\"portMappings\":[{\"containerPort\":3000,\"hostPort\":3000,\"protocol\":\"tcp\",\"name\":\"app-80-tcp\",\"appProtocol\":\"http\"}],\"essential\":true,\"environment\":[{\"name\":\"REDIS_PORT\",\"value\":\"6379\"},{\"name\":\"REDIS_HOST\",\"value\":\"shortnamen12-cupzca.serverless.apse1.cache.amazonaws.com\"},{\"name\":\"NODE_ENV\",\"value\":\"production\"}],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/url-shortener-task\",\"awslogs-create-group\":\"true\",\"awslogs-region\":\"ap-southeast-1\",\"awslogs-stream-prefix\":\"ecs\"}},\"systemControls\":[]}]"
    family = "url-shortener-task"
    task_role_arn = "arn:aws:iam::787987774269:role/ecsTaskExecutionRole"
    execution_role_arn = "arn:aws:iam::787987774269:role/ecsTaskExecutionRole"
    network_mode = "awsvpc"
    requires_compatibilities = [
        "FARGATE"
    ]
    cpu = "1024"
    memory = "2048"
}

resource "aws_ecs_task_definition" "ECSTaskDefinition2" {
    container_definitions = "[{\"name\":\"nginx\",\"image\":\"787987774269.dkr.ecr.ap-southeast-1.amazonaws.com/urls/nginx2:latest\",\"cpu\":0,\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\",\"name\":\"nginx-80-tcp\",\"appProtocol\":\"http\"}],\"essential\":true,\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/shortname-nginx\",\"awslogs-create-group\":\"true\",\"awslogs-region\":\"ap-southeast-1\",\"awslogs-stream-prefix\":\"ecs\"}},\"systemControls\":[]}]"
    family = "shortname-nginx"
    task_role_arn = "arn:aws:iam::787987774269:role/ecsTaskExecutionRole"
    execution_role_arn = "arn:aws:iam::787987774269:role/ecsTaskExecutionRole"
    network_mode = "awsvpc"
    requires_compatibilities = [
        "FARGATE"
    ]
    cpu = "1024"
    memory = "2048"
}

resource "aws_ecr_repository" "ECRRepository" {
    name = "urls/app"
}

resource "aws_ecr_repository" "ECRRepository2" {
    name = "urls/nginx2"
}

resource "aws_ecr_repository" "ECRRepository3" {
    name = "urls/nginx"
}

resource "aws_acm_certificate" "CertificateManagerCertificate" {
    domain_name = "*.dongzh.store"
    subject_alternative_names = [
        "*.dongzh.store"
    ]
    validation_method = "DNS"
}

resource "aws_cloudwatch_log_group" "LogsLogGroup" {
    name = "/ecs/shortname-nginx"
}

resource "aws_cloudwatch_log_group" "LogsLogGroup2" {
    name = "/ecs/url-shortener-task"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/067406f063614c758d116107cbd3362c"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream2" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/1fd07ea84ba4453b8203ea16b4f1fa80"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream3" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/203778c04d63421b85640a026e751951"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream4" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/25b9064ebaf94ebe8016711d58700022"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream5" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/2f278a77a5ff45a0bf82189744a495c4"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream6" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/33700cdeac3748e0b4e04d35a61b6731"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream7" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/3e4b1ab413044b4ba69bf36ef8dbd4d8"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream8" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/49124ea0087542159fd042a675d0e9d1"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream9" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/4d6d280baa8d478e9b46542ee7bf4de4"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream10" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/566f4873d3ba4a0a815aa78c443f081e"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream11" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/57a0d371701a49efaa46a8f2f620ca3f"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream12" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/5be0279826dc43d7963df0440149c94b"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream13" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/5d5f552873f9476ca030125aae61ead4"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream14" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/6bd76cfb1ed94c9ca7408bd45d1ec01d"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream15" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/6c795885ab144f3eb0b3b5318d9610bd"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream16" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/70788f0552e848a2bd1deee5794f82c4"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream17" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/8fbecbc9f0a641c39f98114a388c42fd"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream18" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/9b71e20a33794df2a52b4b0cfaa8b3cb"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream19" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/a381e390082e42ff945e834030028cdc"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream20" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/ac57d12486a64b12a92736c4c161ec6e"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream21" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/cb8eb4d5f3fc49fc9e420fa5c6ba07b1"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream22" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/d295430bacae4cfcaea7d95d33733d79"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream23" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/e2da84d46b4d4be4a5a30c866223d0aa"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream24" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/e683b4fcd2404642b8e9f499a1114158"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream25" {
    log_group_name = "/ecs/shortname-nginx"
    name = "ecs/nginx/fb9b87c324914211b60bd4664ce6e5ff"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream26" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/0200c20447614cbe9852dd0ff3886680"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream27" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/0a6c30884fd347b39066ba0f332b3e1b"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream28" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/0bf409c158cd4317a6ec36cf76190887"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream29" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/1e49d00ca8184fce815194be2a9eeb06"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream30" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/21987c8391214e5e8df824aa25a60fef"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream31" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/222503fc3990469582b59f5287f8a020"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream32" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/23d8c478ef714818a2b0bd7dfaa5e096"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream33" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/2f4276110613440da4f68ec76dcc2bb6"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream34" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/3ec55e57f7834f4ab5ca7a2d3f0526ea"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream35" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/5d3be5ca9d6649aa8fd06fd703ead0aa"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream36" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/71b5cee00d2a48ad99f03e777076961e"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream37" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/79e12ee3a3f845a2a1ec5f14efbfe71b"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream38" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/84032dc5824344ae8ba9cd5fdf6a797f"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream39" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/8e8893ba0c534777b718d9e579903688"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream40" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/91769b404d4341a39081350b8d10113b"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream41" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/95fe50ff734142bcb464e5830c011605"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream42" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/98edacbd3ef04034a1db8235e5aca4de"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream43" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/99726f33bfe14d979d9e99e280ee94ef"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream44" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/9eae1b1457114bfbbd233f6d7d8090e7"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream45" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/b1f813f450f64ffa89b85011738e416f"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream46" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/bf64e46371fd408ebf936ded454214b9"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream47" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/cc248e7aba774943a9c3602e1c76425e"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream48" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/d66a3a50cfe74d74a2d918466107e012"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream49" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/dce7694ea6164081b9696a2686c962a4"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream50" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/ebd67adbfe514b10a73935cfe768155f"
}

resource "aws_cloudwatch_log_stream" "LogsLogStream51" {
    log_group_name = "/ecs/url-shortener-task"
    name = "ecs/app/f2329ca2b52a428ab0c1cfbf0731c3b5"
}

resource "aws_route53_zone" "Route53HostedZone" {
    name = "shortname.internal."
}

resource "aws_route53_record" "Route53RecordSet" {
    name = "shortname.internal."
    type = "NS"
    ttl = 172800
    records = [
        "ns-1536.awsdns-00.co.uk.",
        "ns-0.awsdns-00.com.",
        "ns-1024.awsdns-00.org.",
        "ns-512.awsdns-00.net."
    ]
    zone_id = "Z000624432VCC70CZ2NZL"
}

resource "aws_route53_record" "Route53RecordSet2" {
    name = "shortname.internal."
    type = "SOA"
    ttl = 15
    records = [
        "ns-1536.awsdns-00.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
    ]
    zone_id = "Z000624432VCC70CZ2NZL"
}

resource "aws_route53_record" "Route53RecordSet3" {
    name = "shortname-app.shortname.internal."
    type = "A"
    set_identifier = "3ec55e57f7834f4ab5ca7a2d3f0526ea"
    multivalue_answer_routing_policy = true
    ttl = 15
    health_check_id = "8256520a-780d-47ba-b3df-b7d54b6b448d"
    records = [
        "10.68.21.58"
    ]
    zone_id = "Z000624432VCC70CZ2NZL"
}

