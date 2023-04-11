# IP App

This application saves the ip on mysql and fetch from table on list page.


This repository contains following parts
1. Helm chart for EKS
2. Terraform Infra Code
3. Terraform modules


### Tools Used
* Helm
* Terraform 
* Terragrunt

Main page view
```text
Your current IP:
103.93.218.140
```

List page view
```text
IP's List
#	IP	Created
1	103.93.218.140	2023-04-11 11:20:18
2	103.93.218.140	2023-04-11 11:20:24
3	103.93.218.140	2023-04-11 11:20:25
```

### Infrastructure Details

A VPC is created with two public subnets and two private subnets. All infrastructure is deployed on private subnet, just LB is using Public subnets to server traffic from the internet.

Terrafrom code is modulized for dynamic usage.

## Environment Setup 
```bash
cd terraform/infrastructure
terragrunt init
terraform plan
terraform apply
```

Helm for initial Deployment
```bash
helm upgrade --install ipapp ./helm-chart --wait
```

## TODO
1. Create domain
2. Refine vpc endpoint rules for internal network
3. Helm notes file
4. Sops configuration in helm
5. Infrastructure Diagram

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.