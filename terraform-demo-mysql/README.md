# SETUP MySSQL Database
## Sign in
```
az login
```
## Generate ssh key
```
ssh-keygen -t rsa -b 4096 -f mykey
```
## Run Terraform Init
```
terraform init
```
## Run Terraform Apply
```
terraform apply
```
## SSH into virtual machine
```
The output of terraform show  the public ip
```
## Source
https://learn.microsoft.com/en-us/azure/mysql/flexible-server/quickstart-create-terraform?tabs=azure-cli