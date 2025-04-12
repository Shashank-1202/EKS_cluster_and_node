# EKS_cluster_and_node

Terraform EKS Cluster Deployment
This Terraform configuration provisions an Amazon EKS (Elastic Kubernetes Service) cluster with a worker node group. The setup includes:

An EKS cluster with a specified IAM role
A node group for running workloads
Required IAM policies and role attachments
Configurable parameters for subnets, scaling, and authentication
Prerequisites
Ensure you have the following installed and configured:

Terraform (v1.0+ recommended)
AWS CLI (configured with necessary credentials)
kubectl (to interact with the EKS cluster)
Note - I have used default VPC and available subnet. If you are creating new VPC and subnet change in the configuration accordingly.

Files Overview
variables.tf
Defines configurable parameters:

eks_cluster_name: Name of the EKS cluster
eks_cluster_role_name: IAM role for the EKS cluster
eks_node_role_name: IAM role for worker nodes
subnet_ids: List of subnets for the cluster and node group
node_group_name: Name of the node group
scaling_config: Desired, min, and max worker node count
main.tf
Contains the Terraform resources to:

Fetch existing IAM roles
resource.tf
Containes required resources:

Attach necessary IAM policies
Create an EKS cluster and node group
output.tf
Defines outputs:

EKS cluster ID, ARN, and API endpoint
Node group name
creation of directory terraform and files
alt text

Deployment Steps
Initialize Terraform

terraform init
Validate configuration

terraform validate
Plan deployment

terraform plan
Apply configuration

terraform apply -auto-approve
Retrieve cluster details

terraform output
Configure kubectl

aws eks --region <your-region> update-kubeconfig --name <eks-cluster-name>
Initialisation and configuration
alt text

Cleanup
To remove the infrastructure, run:

terraform destroy -auto-approve
Note
Ensure your AWS credentials have necessary permissions.
Modify variables.tf to customize your deployment.
Use kubectl get nodes to verify worker nodes are running.

![alt text](image.png)
![alt text](image-1.png)