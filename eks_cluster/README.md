using eksctl
eksctl create cluster --name demo-cluster --version 1.29 --region eu-east-1 --nodegroup-name demo-noda1 --node-type t2.micro  --nodes 1 --nodes-min 1 --nodes-max 3
