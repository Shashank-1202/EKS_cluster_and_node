# Create EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_public_access = true
  }

  access_config {
    authentication_mode = "API"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# Fetch existing IAM Role for Worker Nodes
data "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
}

# Attach necessary policies for Worker Nodes
resource "aws_iam_role_policy_attachment" "worker_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = data.aws_iam_role.eks_node_role.arn
}

resource "aws_iam_role_policy_attachment" "worker_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = data.aws_iam_role.eks_node_role.arn
}

resource "aws_iam_role_policy_attachment" "worker_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = data.aws_iam_role.eks_node_role.arn
}

# Create EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker_AmazonEC2ContainerRegistryReadOnly
  ]
}

# Automatically Update Kubeconfig for kubectl Access
resource "null_resource" "update_kubeconfig_v2" {
  triggers = {
    cluster_name = aws_eks_cluster.main.name
  }

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.main.name}"
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main
  ]
}

# Add Admin IAM Role to aws-auth ConfigMap
resource "null_resource" "configure_aws_auth" {
  triggers = {
    cluster_name = aws_eks_cluster.main.name
  }

  provisioner "local-exec" {
    command = <<EOT
cat <<EOF | kubectl apply --validate=false -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${data.aws_iam_role.eks_node_role.arn}
      username: system:node:EC2PrivateDNSName
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${data.aws_iam_role.eks_role.arn}
      username: admin
      groups:
        - system:masters
EOF
EOT
  }

  depends_on = [
    aws_eks_cluster.main,
    null_resource.update_kubeconfig_v2
  ]
}
