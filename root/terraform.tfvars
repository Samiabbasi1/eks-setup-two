env                        = "cloud"
aws-region                 = "us-east-1"
vpc-cidr-block             = "10.0.0.0/16"
vpc-name                   = "forjenkins"
igw-name                   = "igw"
pub-subnet-count           = 3
pub-cidr-block             = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
pub-availability-zone      = ["us-east-1a", "us-east-1b", "us-east-1c"]
pub-sub-name               = "subnetpublic"
pri-subnet-count           = 3
pri-cidr-block             = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
pri-availability-zone      = ["us-east-1a", "us-east-1b", "us-east-1c"]
pri-sub-name               = "subnetprivate"
public-rt-name             = "publicroutetable"
private-rt-name            = "privateroutetable"
eip-name                   = "elasticipngw"
ngw-name                   = "ngw"
eks-sg                     = "ekssg"
is-eks-cluster-enabled     = true
cluster-version            = "1.29"
cluster-name               = "ekscluster"
endpoint-private-access    = true
endpoint-public-access     = false
ondemand_instance_types    = ["t3a.medium"]
spot_instance_types        = ["c5a.large", "c5a.xlarge", "m5a.large", "m5a.xlarge", "c5.large", "m5.large", "t3a.large", "t3a.xlarge", "t3a.medium"]
desired_capacity_on_demand = "1"
min_capacity_on_demand     = "1"
max_capacity_on_demand     = "5"
desired_capacity_spot      = "1"
min_capacity_spot          = "1"
max_capacity_spot          = "10"
addons = [
  {
    name    = "vpccni",
    version = "v1.18.1-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.11.1-eksbuild.9"
  },
  {
    name    = "kubeproxy"
    version = "v1.29.3-eksbuild.2"
  },
  {
    name    = "awsebscsidriver"
    version = "v1.30.0-eksbuild.1"
  }
]