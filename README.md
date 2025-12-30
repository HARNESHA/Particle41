# Practical41  
---
## Minimalist Application Development on Kubernetes (Kind) – Task 1

The objective of this task is to demonstrate:

- Containerization best practices  
- Secure Kubernetes deployment  
- Namespace isolation  
- Service exposure using NodePort  
- Verification from outside the cluster  

### Overview

The **Timestamp Microservice** is a simple Node.js application that returns:

- The **current timestamp**
- The **client IPv4 address**

This repository includes:

- Application source code  
- A secure Dockerfile  
- Kubernetes Deployment & Service manifests  
- Kind cluster configuration  
- Supporting documentation  

### Repository Structure

```text

├── app.js
├── package.json
├── Dockerfile
├── microservice.yaml
└── kind-cluster.yaml
````

### Prerequisites

Ensure the following software is installed with suitable versions:

* Docker
* kubectl
* Kind (Kubernetes in Docker)

### Verify Installation

```bash
docker --version
kubectl version --client
kind --version
```

<img width="1062" height="205" alt="image" src="https://github.com/user-attachments/assets/06c044d2-cef0-4297-9c95-2138c580980e" />


### Clone the Repository

```bash
git clone https://github.com/HARNESHA/Particle41-Practical.git
cd Particle41-Practical
```

### Dockerfile

* Uses a minimal base image
* Runs the application as a non-root user
* Optimized for security and production usage

### microservice.yaml

**Deployment**

* Minimal required permissions
* Secure `securityContext`
* Runs containers as non-root

**Service**

* NodePort service
* Exposes application on port `32000`
* Accessible from outside the cluster

### Environment Setup

```bash
kind create cluster --config kind-cluster.yaml
```

<img width="1195" height="341" alt="image" src="https://github.com/user-attachments/assets/21f195f2-0ea0-4814-8a3b-d42728897cf3" />

Verify Cluster Creation with below commads.

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

<img width="1482" height="567" alt="image" src="https://github.com/user-attachments/assets/24b3f5dc-d040-40ec-925e-c3ba27be07bb" />

### Create a Dedicated Namespace & Deploy the Timestamp Service
* Create a new namespace
* Apply the Kubernetes Manifest & Verify Deployed Resources
* Ensure all pods are in the **Running** state

```bash
kubectl create namespace simple-timestamp
kubectl get namespaces
kubectl apply -f microservice.yaml -n simple-timestamp
```
<img width="993" height="267" alt="image" src="https://github.com/user-attachments/assets/711e8edc-4c07-4d89-8be1-6b43241d991f" />

<img width="1106" height="522" alt="image" src="https://github.com/user-attachments/assets/1828d0cd-4ac6-40e1-91f2-121f43e19561" />


### Get Node IP Address & Access the Service from Outside the Cluster

```bash
for i in {1..5}; do
  for ip in $(kubectl get nodes -o wide --no-headers | awk '{print $6}'); do
    curl -s --connect-timeout 3 http://$ip:32000 | jq .
    echo "--------------------------------------------"
  done
done
```
<img width="591" height="582" alt="image" src="https://github.com/user-attachments/assets/f683d10a-bc74-4fa3-a66f-f6261f14456e" />

### Verification Checklist

* Kind cluster created successfully
* Namespace `simple-timestamp` created
* Deployment running with secure context
* NodePort service exposed on port `32000`
* Service accessible from outside the cluster

### Best Practices Followed

* Non-root container execution
* Minimal Docker base image
* Kubernetes `securityContext` enforcement
* Namespace isolation
* Logs written to stdout
* Separation of Deployment and Service

---
## Terraform and AWS: create an EKS cluster – Task 2

### Terraform Deployment Guide (Dev Environment)

This repository provisions AWS infrastructure using Terraform with a **remote S3 backend**.

Directory structure follows a **multi-environment layout**, with `dev` as the active environment.

### Prerequisites

* Terraform ≥ **1.6**
* AWS CLI ≥ **v2**
* AWS IAM permissions to:
  * Create S3 buckets
  * Manage infrastructure resources
* An AWS account (via assumed role or local credentials)
<img width="785" height="106" alt="image" src="https://github.com/user-attachments/assets/5f3a0205-df73-4309-bda5-3268a5d4ceb4" />

### Directory Structure (Relevant)

```
env/
└── dev/
    ├── backend.config.hcl
    ├── main.tf
    ├── provider.tf
    └── variables.tf

modules/
└── eks/

vars/
└── dev.terraform.tfvars
```

### Step 1: Create S3 Backend Bucket

Terraform state is stored remotely in an S3 bucket.

Create the bucket **once** before running Terraform:

```bash
aws s3api create-bucket \
  --bucket tfstate-dev-Particle41-eks \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

Enable versioning (recommended):

```bash
aws s3api put-bucket-versioning \
  --bucket tfstate-dev-Particle41-eks \
  --versioning-configuration Status=Enabled
```

### Step 2: Update Backend Configuration

Edit the backend configuration file:

**`env/dev/backend.config.hcl`**

```hcl
bucket  = "tfstate-dev-Particle41-eks"
key     = "eks/dev/terraform.tfstate"
region  = "ap-south-1"
encrypt = true
```

The bucket name **must be globally unique**.

### Step 3: Initialize Terraform & Validate Configuration

```bash
terraform init -backend-config=backend.config.hcl
terraform validate

```
This will:

* Configure the S3 backend
* Download required providers
* Initialize modules
<img width="951" height="320" alt="image" src="https://github.com/user-attachments/assets/6666b5e3-8aa2-4d95-a41d-97c928e9f4cc" />

### Step 4: Generate Execution Plan &  Apply Infrastructure

This shows all infrastructure changes **before** applying them.

```bash
terraform plan \
  -var-file=../../vars/dev.terraform.tfvars \
  -out=tfplan
```
Now apply the infrastructure changes **after reviwing the plan** output.
Terraform will:

* Create / update AWS resources
* Store state securely in S3

```bash
terraform apply tfplan
terraform output
```
<img width="781" height="143" alt="image" src="https://github.com/user-attachments/assets/63ceca56-e366-4aa5-a45e-a8e29431fe0f" />
<img width="1145" height="245" alt="image" src="https://github.com/user-attachments/assets/c658279e-c18b-4d62-a028-16dea1a01c7d" />

### Step 5: Access the cluster & Deploy the application

```bash
aws eks update-kubeconfig --name PracticeApp-Eks-cluster --region ap-south-1
kubectl apply -f microservice.yaml
```
<img width="1136" height="142" alt="image" src="https://github.com/user-attachments/assets/8c12a0c3-35de-4ee3-8e22-f7a2233f1dd8" />
<img width="742" height="326" alt="image" src="https://github.com/user-attachments/assets/ffb2c5d5-01a8-47df-b3b2-2e1becf3ca59" />


### Rollback / Changes

* Modify Terraform code
* Re-run `plan` and `apply`
* Terraform handles incremental updates safely

To destroy resources & Cleanup (if required):

```bash
terraform destroy \
  -var-file=../../vars/dev.terraform.tfvars
```

### Notes

* Backend bucket must exist **before** `terraform init`
* Do **not** commit Terraform state files
* This setup is compatible with CI/CD pipelines using AWS AssumeRole (OIDC)

## Summary

This workflow ensures:

* Remote state management using S3
* Clean environment separation
* Safe, repeatable infrastructure deployments
