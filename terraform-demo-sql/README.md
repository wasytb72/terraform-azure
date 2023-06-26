# What is going to be deployed
Create Azure Databse for Azure SQL
Configure the Azure SQL Firewall
User Vnet Service Endpoints
Create virtual machine
Use SQL command line to test connection to the DB
# SETUP MSSQL Database
## Sign In
```
az login
```
## Generate ssh key
```
ssh-keygen -t rsa -b 4096 -f mykey
```
## Run Terraform apply
```
terraform init
```
## Run Terraform plan
```
terraform plan -out deployazsql
```
## Run Terraform apply
```
terraform apply "deployazsql"
```
## Ssh into the Virtual machine
```
The output of terraform shows the public IP
````
```
ssh -i .ssh/authorized_keys/terrademo wasytb@<public IP>