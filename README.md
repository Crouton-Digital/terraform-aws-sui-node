# terraform-aws-sui-node
Terraform module for deploy sui node on AWS

## Deploy SUI node
```bash
# Configure AWS credentional 
aws configure

# Search Linux image if need  
aws ec2 describe-images --owners amazon --filters "Name=name,Values=debian-11-amd64*" --query "Images | [0].ImageId" --output text\n

# Create SSH keypair
aws ec2 create-key-pair --key-name sui-node-key --query 'KeyMaterial' --region eu-west-2 --output text > aws-sui-node-key.pem

```

```bash
git clone https://github.com/Crouton-Digital/terraform-aws-sui-node.git
cd terraform-aws-sui-node/examples/sui-node

# Edit instance.tf
module "sui" {
  source         = "Crouton-Digital/sui-node/aws"
  version        = "0.1.0" # Set last module version

  aws_region            = "eu-west-2"
  aws_availability_zone = "eu-west-2a"
  aws_image_name        = "debian-11-amd64*"
  aws_instance_type     = "t2.medium"
  vpc_name              = "sui-node"
  ssh_key_name          = "sui-node-key"
  sui_network           = "mainnet"
  app_version           = "mainnet"
  storage_persistent_data = "10"
}

output "node_host_ip" {
  value = module.sui.host_ip
}

# Terraform apply
terraform init 
terraform apply 

# show sui node IP
terraform output
```

![terraform_apply.gif](images%2Fterraform_apply.gif)

## Connect to SUI Node use ssh 
 ```bash
 chmod 0600 aws-sui-node-key.pem
 ssh admin@<ip sui node> -i aws-sui-node-key.pem
 ```

![sui_ssh_login.gif](images%2Fsui_ssh_login.gif)

## Configure and Management 

#### START / STOP / LOGS DOCKER STACK CONTAINERS
```bash
# Go to docker stack folder 
cd /opt/sercvice

# list running docker stack containers 
docker-compose ps 

# stop docker stack containers 
docker-compose stop 

# start docker stack containers 
docker-compose up -d 

# print realtime logs docker stack containers 
docker-compose logs -f --tail=500
```

On /opt/service/volumes/ you can see all  configuration for custom change

#### How to update

```bash
cd /opt/service
vim docker-compose.yml (Change version image tag)

docker-compose up -d 
```


https://docs.sui.io/guides/operator/sui-full-node