# Amazon AWS EKS, RDS PostgreSQL, TeamCity, S3 Storage, ALB  with terraform

Assuming you already have Amazon AWS account we will need additional binaries for AWS CLI, terraform, kubectl and aws-iam-authenticator.

* Initial tooling setup aws cli , kubectl and terraform
* Creating terraform IAM account with access keys and access policy
* Creating back-end storage for tfstate file in AWS S3 
* Creating Kubernetes cluster on AWS EKS and RDS on PostgreSQL
* Working with kubernetes "kubectl" in EKS

## Initial tooling setup aws-cli, kubectl, terraform and aws-iam-authenticator

Assuming you already have AWS account and [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html) and [AWS CLI configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) for your user account we will need additional binaries for, terraform and kubectl.

### Deploying terraform

#### terraform for OS X

```sh
curl -o terraform_0.11.7_darwin_amd64.zip \
https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_darwin_amd64.zip

unzip terraform_0.11.7_linux_amd64.zip -d /usr/local/bin/
```

#### terraform for Linux

```sh
curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip > \
terraform_0.11.7_linux_amd64.zip

unzip terraform_0.11.7_linux_amd64.zip -d /usr/local/bin/
```

#### terraform installation verification

Verify terraform version 0.11.7 or higher is installed:

```sh
terraform version
```

### Deploying kubectl

#### kubectl for OS X

```sh
curl -o kubectl https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/darwin/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/
```

#### kubectl for Linux

```sh
wget https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/
```

#### kubectl installation verification

```sh
kubectl version --client
```

### Deploying aws-iam-authenticator

[aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) is a tool developed by [Heptio](https://heptio.com/) Team and this tool will allow us to manage EKS by using kubectl

#### aws-iam-authenticator for OS X

```sh
curl -o aws-iam-authenticator \
https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator

chmod +x ./aws-iam-authenticator

cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
```

#### aws-iam-authenticator for Linux

```sh
curl -o aws-iam-authenticator \
https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator

chmod +x ./aws-iam-authenticator

cp ./aws-iam-authenticator $HOME/.local/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
```

#### aws-iam-authenticator installation verification

```sh
aws-iam-authenticator help
```

### Authenticate to AWS

In below example I will be using US East "us-east-2""

```sh
aws configure
```

## Creating terraform IAM account with access keys and access policy

1st step is to setup terraform admin account in AWS IAM

### Create IAM terraform User

```sh
aws iam create-user --user-name terraform
```

### Add to newly created terraform user IAM admin policy

> NOTE: For production or event proper testing account you may need tighten up and restrict access for terraform IAM user


```sh
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### Create access keys for the user

> NOTE: This Access Key and Secret Access Key will be used by terraform to manage infrastructure deployment

```sh
aws iam create-access-key --user-name terraform
```

### update terraform.tfvars file with access and security keys for newly created terraform IAM account


## Creating back-end storage for tfstate file in AWS S3

Once we have terraform IAM account created we can proceed to next step creating dedicated bucket to keep terraform state files

### Create terraform state bucket

> NOTE: Change name of the bucket, name should be unique across all AWS S3 buckets

```sh
aws s3 mb s3://teamcity-state-bucket --region us-east-2
```

### Enable versioning on the newly created bucket

```sh
aws s3api put-bucket-versioning --bucket teamcity-state-bucket --versioning-configuration Status=Enabled
```

## Creating Kubernetes cluster on AWS EKS and RDS on PostgreSQL

Now we can move into creating new infrastructure, eks and rds with terraform

I will use terraform modules to keep my code clean and organized

Terraform modules will create

* VPC
* EKS cluster
* RDS with PostgreSQL
* Namespace for TeamCity Server ang Agents
* TeamCity Server and 2 TeamCity Agents
* ALB controller
* S3 Storage for storing artifacts.(Persistent Storage for pods)

#### Initialize and pull terraform cloud specific dependencies

```sh
terraform init
```

Before we can start will need to update variables and add db password to terraform.tfvars

```sh
echo 'db_password = "Your_DB_Passwd."' >> terraform.tfvars
```

#### It's a good idea to sync terraform modules

```sh
terraform get -update
```

### View terraform plan

```sh
terraform plan
```

### Apply terraform plan

> NOTE: building complete infrastructure may take more than 10 minutes.

```sh
terraform apply
```

Run the following command to retrieve the access credentials for your cluster and configure kubectl.

```sh
 aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```