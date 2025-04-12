# Fetch existing IAM Role for EKS Cluster
data "aws_iam_role" "eks_role" {
  name = var.eks_cluster_role_name
}

# Attach necessary policy to EKS Cluster role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = data.aws_iam_role.eks_role.name
}