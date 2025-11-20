## Pre-requisite
- Install [terraform v1.5.5](https://www.terraform.io/downloads.html)
- Setup the [aws cli credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with `asmigar` profile name.

## Create Infra
Run below command to create EC2 instance
```bash
terraform init; terraform apply --auto-approve
```
This will create instance with wordpress installed and output for wordpress setup site.

## TODO
- [ ] Use IAM auth to connect to RDS from EC2
- [ ] Don't store the private ssh key resource in state file