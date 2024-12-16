# Microservice MERN Stack with EKS Infrastructure

## Overview  
This project provisions an EKS cluster using Terraform and automates the deployment of a MERN stack application using Jenkins. Additionally, there is an option to use GitHub Actions workflows for CI/CD. The infrastructure is designed with cost optimization and flexibility in mind, leveraging managed node groups with both on-demand and spot instances. This is the first part focusing on the provisioning of the infrastructure

## Features  
- **Infrastructure as Code (IaC):** Terraform is used to provision an Amazon Elastic Kubernetes Service (EKS) cluster.  
- **Scalability:** The cluster includes a VPC with three public and three private subnets.  
- **Cost Optimization:** On-demand nodes are used for critical infrastructure, while spot nodes are used for non-critical workloads.  
- **CI/CD Integration:** Jenkins automates deployment. A GitHub Actions workflow is also provided as an alternative.  
- **Customizable Infrastructure:** A flexible `terraform.tfvars` file allows teams to easily customize infrastructure parameters.  

## Directory Structure  
```plaintext
C:/Users/biekr/OneDrive/Desktop/projects/microservice_mern_stack_eks_infrastructure/
|-- Jenkinsfile                      # Jenkins pipeline configuration for CI/CD.
|-- bastion_n_jenkins_scripts/       # Scripts for setting up Bastion host and Jenkins.
|   |-- README.md
|   |-- bastion_user_data.sh         # User data script for setting up the Bastion host.
|   `-- jenkins_server_userdata.sh   # User data script for provisioning the Jenkins server.
|-- eks_cluster/                     # Terraform configuration for deploying the EKS cluster.
|   |-- backend.tf                   # Remote state backend configuration.
|   |-- main.tf                      # Main Terraform configuration for the cluster.
|   |-- project_locals.tf            # Local variables used across the project.
|   |-- terraform.tfvars             # File for setting user-defined variable values.
|   `-- variables.tf                 # Variables definitions for the infrastructure.
`-- modules/                         # Reusable Terraform modules.
    |-- certs_oidc.tf                # OIDC provider configuration for EKS.
    |-- eks.tf                       # EKS cluster configuration.
    |-- iam.tf                       # IAM roles and policies for the cluster.
    |-- igw.tf                       # Internet gateway configuration.
    |-- locals.tf                    # Local variables specific to modules.
    |-- nat_gw.tf                    # NAT gateway configuration.
    |-- route_tables.tf              # Route tables for public and private subnets.
    |-- subnets.tf                   # Subnet configurations.
    |-- variables.tf                 # Module-specific variables.
    `-- vpc.tf                       # VPC configuration.
```
## Requirements  
To deploy the infrastructure, you need the following tools installed:  
- **AWS CLI**  
- **Terraform**  
- **Jenkins**  

### Pre-requisites  
#### Set Up AWS Credentials:  
1. Ensure you configure AWS CLI with your credentials:  
   ```bash
   aws configure
   ```  
2. Install Required Tools: Follow the links in the "Requirements" section to install the dependencies.  

## Setup Instructions  

### Run Infrastructure Locally  
1. Navigate to the `eks_cluster` directory:  
   ```bash
   cd eks_cluster
   ```  
2. Initialize Terraform:  
   ```bash
   terraform init
   ```  
3. Validate the configuration:  
   ```bash
   terraform validate
   ```  
4. Apply the Terraform configuration:  
   ```bash
   terraform plan
   terraform apply
   ```  

#### To Destroy the Infrastructure:  
Run the following command:  
   ```bash
   terraform destroy
   ```  

### Deploy Infrastructure Using Jenkins or GitHub Actions  
#### Jenkins Setup:  
1. Launch an EC2 instance with the following specifications:  
   - Instance type: `t2.medium`  
   - Minimum storage capacity: **20GB**  
2. Use the `bastion_n_jenkins_scripts/jenkins_server_userdata.sh` script to set up the necessary tools and configure the server.  
3. Once the server is ready, use the provided Jenkins pipeline (`Jenkinsfile`) for automating the deployment process.  

For additional details, explore the provided `bastion_n_jenkins_scripts/README.md`.  

### Full Documentation  
[Click here](#) for full documentation on the infrastructure and deployment. There are important things like ensuring the cluster gives access to the bastion host that is discussed in the documentation.

## Contact  
For any issues or questions, feel free to contact me at:  
- **Email:** [beikrogodbless@gmail.com](mailto:beikrogodbless@gmail.com)  
