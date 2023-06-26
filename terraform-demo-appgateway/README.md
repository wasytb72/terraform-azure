# Setup Application GW

# Notes

Careful with NSG created by Azure Policy. It can block traffic. Create rules for HTTP Traffic

# Sign in
```
az login
```

# Generate ssh key
```
ssh-keygen -t rsa -b 4096 -f mykey
```
# Run Terraform init
```
terraform init
```

# Run Terraform apply
```
terraform apply
```

# Cleanup Demo
```
terraform destroy
```
