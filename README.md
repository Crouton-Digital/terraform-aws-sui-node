# terraform-aws-sui-node
Terraform module for deploy sui node on AWS


```bash
# Configure AWS credentional 
aws configure

# Search Linux image if need  
aws ec2 describe-images --owners amazon --filters "Name=name,Values=debian-11-amd64*" --query "Images | [0].ImageId" --output text\n

# Create SSH keypair
aws ec2 create-key-pair --key-name sui-node-key --query 'KeyMaterial' --output text > aws-sui-node-key.pem

```