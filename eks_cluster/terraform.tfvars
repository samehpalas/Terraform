vpc_cidr_block= "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] //in each AZ for HA - Private for workload - Public for LB,NATGW..
public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] //in each AZ for HA - Private for internal APP - Public for LB,..
