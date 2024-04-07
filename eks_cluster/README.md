using eksctl #simple to launch, difficult for cleanning up
- aws configure
- eksctl create cluster --name demo-cluster --version 1.29 --region us-east-1 --nodegroup-name demo-noda1 --node-type t2.micro  --nodes 1 --nodes-min 1 --nodes-max 3

for expanding:
eksctl create nodegroup \
  --cluster demo-cluster \
  --region us-east-1 \
  --name nodo2 \
  --node-type m5.large \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 4 

Kubeconfig file will be created automaically in eksctl by cloudformation help
------------------
in case EKS provisioned by terrafom, run update kubeconfig command;aws eks update-kubeconfig --region <region-name> --name <cluster name>
