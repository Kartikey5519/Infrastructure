## Purpose and Expectations
This repository is designed to automate infrastructure deployment and management using Terraform and CI/CD pipelines. 
The primary goals are:
- Ensure consistent infrastructure provisioning.
- Enable easy scaling and modification of infrastructure.
- Automate deployment using CI/CD for increased efficiency and reduced human error.
- Centralize infrastructure state and configurations for better traceability.

## Infrastructure Tools Purpose and Expectations
This repository also includes infrastructure tools to enhance cluster management, monitoring, and security:

### **Ingress NGINX**  
- Provides external access to Kubernetes services using HTTP and HTTPS.
- Enables traffic routing based on host and path-based rules.
- Ensures secure communication using TLS.

### **Prometheus and Grafana**  
- Prometheus collects and stores real-time metrics from Kubernetes components and applications.
- Grafana provides a user-friendly interface for visualizing metrics and creating dashboards.
- Alertmanager handles alerts based on Prometheus metrics for proactive issue resolution.

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
## Infrastructure Tools
The `Infra-tools` directory includes configurations for monitoring and alerting using Prometheus and Grafana.

### **Prometheus Chart**
- **prometheus-windows-exporter** – Prometheus exporter for monitoring Windows-based nodes.
- **alertmanager** – Configuration for handling alerts from Prometheus.
- **grafana** – Dashboard configurations for monitoring Kubernetes clusters.
- **exporters** – Exporter configurations for Kubernetes components like API Server, Scheduler, etc.
- **thanos-ruler** – Configuration for Thanos Ruler to extend Prometheus monitoring capabilities.

### **Key Components:**
- **Templates** – Helm templates for setting up Prometheus, Grafana, and Alertmanager.
- **ServiceMonitors** – Define how Prometheus scrapes metrics from Kubernetes services.
- **Rules** – Alerting rules and recording rules for Prometheus.
- **Ingress** – Configuration for exposing monitoring services.

### **Usage:**
1. Install Prometheus using the provided Helm chart:
   ```sh
   helm install prometheus ./Infra-tools/prometheus-chart
   ```

2. Access Grafana:
   - Username/Password: Defined in the Grafana secret.
   - Access URL: `http://<grafana-url>`

3. View Metrics in Grafana:
   - Use pre-configured dashboards for Kubernetes components.


### **Ingress NGINX**
The `Infra-tools/ingress-nginx` directory contains configurations for setting up NGINX as an ingress controller for Kubernetes.

#### **Key Components:**
- **Controller** – NGINX controller deployment for managing external access to services.
- **Service** – LoadBalancer or NodePort service configuration for exposing the NGINX controller.
- **ConfigMap** – Custom NGINX configurations (timeouts, buffering, etc.).
- **TLS** – Secure communication using TLS certificates.

#### **Usage:**
1. Install NGINX Ingress Controller using Helm:
   ```sh
   helm install ingress-nginx ./Infra-tools/ingress-nginx
   ```

2. Verify the deployment:
   ```sh
   kubectl get pods -n ingress-nginx
   ```

3. Create an Ingress resource to expose services:
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: example-ingress
     namespace: default
   spec:
     rules:
     - host: example.com
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: example-service
               port:
                 number: 80
   ```

### **Prometheus Chart**
The `Infra-tools/prometheus-chart` directory includes configurations for setting up Prometheus and Grafana for monitoring and alerting.

#### **Key Components:**
- **prometheus-windows-exporter** – Prometheus exporter for monitoring Windows-based nodes.
- **alertmanager** – Configuration for handling alerts from Prometheus.
- **grafana** – Dashboard configurations for monitoring Kubernetes clusters.
- **exporters** – Exporter configurations for Kubernetes components like API Server, Scheduler, etc.
- **thanos-ruler** – Configuration for Thanos Ruler to extend Prometheus monitoring capabilities.

#### **Usage:**
1. Install Prometheus using the provided Helm chart:
   ```sh
   helm install prometheus ./Infra-tools/prometheus-chart
   ```

2. Access Grafana:
   - Username/Password: Defined in the Grafana secret.
   - Access URL: `http://<grafana-url>`

3. View Metrics in Grafana:
   - Use pre-configured dashboards for Kubernetes components.