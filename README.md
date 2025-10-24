### ECS envs with shared https ALB

Create shared alb
```bash
cd shared_infra
terraform init
terraform plan
terraform apply -auto-approve
terraform output
```

Update domain dns records
```bash
Update Godaddy dns records with alb_dns_name
```

Create staging ecs
```bash
cd environments/staging
terraform init
terraform plan
terraform apply -auto-approve
```

Create prod ecs
```bash
cd environments/production
terraform init
terraform plan
terraform apply -auto-approve
```

Cleanup
```bash
cd environments/staging
terraform plan -destroy
terraform destroy -auto-approve
```
