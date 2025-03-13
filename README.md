
# Infrastructure Overview

This repository contains infrastructure as code (IaC) for managing cloud-based infrastructure using Terraform. 
It includes buildspec files for CI/CD automation and Terraform configurations for the development environment.

## Directory Structure
```
Infrastructure/
├── tf-Infra/
│   ├── buildspec/
│   │   ├── apply-buildspec.yaml
│   │   ├── destroy-buildspec.yaml
│   │   └── plan-buildspec.yaml
│   └── dev/
│       ├── backend.tf
│       ├── cluster.tf
│       ├── iam.tf
│       ├── main.tf
│       ├── node-group.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── versions.tf
├── tf-modules/
│   ├── modules/
│   │   ├── eks-managed-node-group/
│   │   ├── fargate-profile/
│   │   └── self-managed-node-group/
│   └── templates/
└── README.md
```

## Buildspec Files
The buildspec files are used for automating infrastructure deployment, changes, and destruction using CI/CD pipelines:

### 1. **apply-buildspec.yaml**  
- Executes `terraform apply` command to create or update infrastructure.
- References the Terraform state file to track changes.

### 2. **destroy-buildspec.yaml**  
- Executes `terraform destroy` command to tear down infrastructure resources.
- Ensures that all dependencies are properly handled during cleanup.

### 3. **plan-buildspec.yaml**  
- Executes `terraform plan` command to generate an execution plan.
- Highlights infrastructure changes before applying them.

## Development Environment
The `dev` folder contains Terraform configuration files to define and manage the development environment:

### **backend.tf**  
- Configures the remote backend for storing Terraform state (e.g., S3, Azure Storage).

### **cluster.tf**  
- Defines the Kubernetes cluster resources such as control plane, networking, and DNS.

### **iam.tf**  
- Manages AWS Identity and Access Management (IAM) roles and permissions.

### **main.tf**  
- Primary configuration file that references other modules and components.

### **node-group.tf**  
- Defines the node groups for the Kubernetes cluster (including auto-scaling and instance types).

### **outputs.tf**  
- Captures output values after deployment (e.g., cluster endpoint, node details).

### **providers.tf**  
- Configures Terraform providers such as AWS, Azure, etc.

### **terraform.tfvars**  
- Contains environment-specific variables (e.g., region, instance size).

### **variables.tf**  
- Defines input variables for the Terraform configuration.

### **versions.tf**  
- Specifies the Terraform and provider versions to ensure compatibility.

## Terraform Modules
The `tf-modules` folder contains reusable Terraform modules:

### **eks-managed-node-group**  
- Configures EKS node groups managed by AWS.

### **fargate-profile**  
- Sets up Kubernetes workloads on AWS Fargate (serverless).

### **self-managed-node-group**  
- Configures custom-managed node groups for greater control.

## Templates
The `templates` folder contains user data templates used for bootstrapping nodes:

- **aws_auth_cm.tpl** – AWS authentication configuration template.
- **bottlerocket_user_data.tpl** – User data template for Bottlerocket nodes.
- **linux_user_data.tpl** – User data template for Linux-based nodes.
- **windows_user_data.tpl** – User data template for Windows-based nodes.

## How to Use
1. **Plan** – Generate a plan using `plan-buildspec.yaml`:
   ```sh
   terraform plan
   ```

2. **Apply** – Deploy the infrastructure using `apply-buildspec.yaml`:
   ```sh
   terraform apply
   ```

3. **Destroy** – Clean up resources using `destroy-buildspec.yaml`:
   ```sh
   terraform destroy
   ```

## Best Practices
- Use separate state files for different environments (e.g., dev, stage, prod).
- Enable remote state locking to avoid conflicts.
- Always review the `terraform plan` output before applying changes.
- Follow infrastructure as code (IaC) best practices, including modularization and state isolation.

## Notes
- Ensure that Terraform backend configuration is properly set up in `backend.tf`.
- Make sure IAM roles and permissions are correctly assigned for deployment.
- Review logs after deployment to validate the infrastructure state.