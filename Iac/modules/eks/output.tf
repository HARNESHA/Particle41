output "cluster_arn" {
    value = aws_eks_cluster.this.arn
}
output "node_group_arn" {
    value = aws_eks_node_group.this.arn
}