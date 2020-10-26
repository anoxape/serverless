serverless
==========

Simple serverless web app demo made using AWS Lambda and AWS Elastic Load Balancer.

# Requirements

* AWS account with configured: VPC, public subnet(s), private subnet(s), and internet gateway
* Terraform >= 0.12.26

# Prepare

Create AWS access key to use with Terraform: https://console.aws.amazon.com/iam/home?#security_credential

Init Terraform and enter AWS credentials:
```
terraform init
```

# Configure

Create file `terraform.tfvars`, for example:
```
# app name, used as a prefix for all resources
name = "serverless"

# AWS region
region = "us-west-1"

# VPC ID
vpc_id = "vpc-1"

# VPC private subnet ID list
vpc_private_subnet_ids = [
  "subnet-1",
  "subnet-2",
]

# VPC public subnet ID list
vpc_public_subnet_ids = [
  "subnet-3",
  "subnet-4",
]

# CIDR block list to allow access to LB
lb_ingress_cidr_blocks = ["0.0.0.0/0"]
```
Replace all IDs with those from your VPC.

# Deploy

Run:
```
terraform apply
```

Example:
```
$ terraform apply

[...]

Apply complete! Resources: 19 added, 0 changed, 0 destroyed.

Outputs:

endpoint = serverless-1.us-west-1.elb.amazonaws.com
```

# Validate

Run test 1:
```
curl -H 'Host: test1.foo.io' http://{endpoint}
```

Run test 2:
```
curl -H 'Host: test2.foo.io' http://{endpoint}
```

Use `{endpoint}` value from the deployment output.
 
Example:
```
$ curl -H 'Host: test1.foo.io' http://serverless-1.us-west-1.elb.amazonaws.com
test1

$ curl -H 'Host: test2.foo.io' http://serverless-1.us-west-1.elb.amazonaws.com
test2
```

# Cleanup

Run:
```
terraform destroy
```

Example:
```
$ terraform destroy

[...]

Destroy complete! Resources: 19 destroyed.
```
