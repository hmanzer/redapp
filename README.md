# redapp

This is a simple webpage in nodejs. The infrastructure is built on AWS (ALB, EC2). The VPC has private subnets (outbound internet via NAT gateway) and public subnets (internet gateway) The EC2s are put in private subnets and ALB has public subnets attached.

The deployment is done via Codedeploy. The appspec file and scripts are in app/ folder

The integration is done via Jenkins and sent to codedeploy.

**Table of Contents**
 - [redapp]
  - [app]
  - [infrastructure]
    - [frontend]
    - [modules]
      - [redapp_frontend]
      - [redapp_vpc]
    - [s3-backend]
## app
### codedeploy
The codedeploy scripts, index.js, home.html and appspec.yml are here


## infrastructure
### frontend
this deploys frontend VPC and all other infrastructure like VPC, subnets, internet gateway, NAT gatewway, Route tables, ASG, TG, ALB, CodeDeploy, IAM Role and Jenkins user
### modules
#### redapp_vpc
This creates the VPC and its resources.
#### redapp_frontend
This creates the rest of the infrastructure

### s3-backend
This creates the s3 bucket and dynamodb table used for remote state file and state locking <br>
