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

#### terraform for macOS

First, install the Hashicorp tap

```sh
brew tap hashicorp/tap
```

Now, install Terraform with hashicorp/tap/terraform

```sh
brew install hashicorp
```

[How to install terraform on another platforms](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)

### Deploying kubectl

#### kubectl for macOS

```sh
brew install kubectl
```

Test to ensure the version you installed is up-to-date:

```sh
kubectl version --client
```

[Install and Set UP kubectl on another platforms](https://kubernetes.io/docs/tasks/tools/)

### Deploying aws-iam-authenticator

[aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) is a tool developed by [Heptio](https://heptio.com/) Team and this tool will allow us to manage EKS by using kubectl

#### aws-iam-authenticator for macOS

Install the aws-iam-authenticator with the following command.

```sh
brew install aws-iam-authenticator
```

Test that the aws-iam-authenticator binary works

```sh
aws-iam-authenticator help
```

[Installing aws-iam-authenticator on another platforms](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

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

Now we can move into creating new infrastructure, eks, rds, teamcity, s3 storage and TeamCity with terraform

I will use terraform modules to keep my code clean and organized

Terraform modules will create

* VPC
* EKS cluster
* RDS with PostgreSQL
* Kubernetes Namespace for TeamCity Server ang Agents
* TeamCity Server and 2 TeamCity Agents
* AWS Load Balancer Controller
* S3 Storage (Persistent Storage for pods)
* [Dataset Operator](https://github.com/datashim-io/datashim)

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

#### Set Up RDS PostgreSQL for TeamcityServer

TODO:not forget
```sh

```