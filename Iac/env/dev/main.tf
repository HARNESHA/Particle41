module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"

  name = var.ApplicationName
  cidr = var.VpcCidrBlock

  azs             = var.azs
  public_subnets  = var.public_subnets_cidrs
  private_subnets = var.private_subnets_cidrs

  create_vpc = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  map_public_ip_on_launch = true

  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = []
  outpost_subnets     = []

  public_dedicated_network_acl  = false
  private_dedicated_network_acl = false

  tags = local.Common_Tags
}

module "eks" {
  source           = "../../modules/eks"
  application_name = var.ApplicationName
  eks_version      = var.eks_version

  eks_addons = var.eks_addons

  master_subnet_ids     = module.vpc.public_subnets
  node_group_subnet_ids = module.vpc.private_subnets

  node_group_desired_capacity = var.node_group_desired_capacity
  node_group_max_capacity     = var.node_group_max_capacity
  node_group_min_capacity     = var.node_group_min_capacity

  node_instance_type       = var.node_instance_type
  node_group_capacity_type = var.node_group_capacity_type
  tags = local.Common_Tags
}