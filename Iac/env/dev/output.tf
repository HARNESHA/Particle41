output "infra_details" {
  description = "Infra Creations Details"
  value = {
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    cluster_arn = module.eks.cluster_arn
    node_group_arn = module.eks.node_group_arn
  }
}
