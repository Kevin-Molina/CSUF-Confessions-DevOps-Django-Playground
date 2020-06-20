destroy-all: destroy-service destroy-task destroy-ec2 destroy-cluster \
destroy-alb destroy-sgs destroy-iam destroy-vpc

apply-all: apply-vpc apply-iam apply-sgs apply-alb apply-cluster \
apply-ec2 apply-task apply-service

apply-vpc:
	cd vpc && terraform init && terraform apply -auto-approve
destroy-vpc:
	cd vpc && terraform init && terraform destroy -auto-approve

apply-iam:
	cd iam && terraform init && terraform apply -auto-approve
destroy-iam:
	cd iam && terraform init && terraform destroy -auto-approve

apply-sgs:
	cd security-groups && terraform init && terraform apply -auto-approve
destroy-sgs:
	cd security-groups && terraform init && terraform destroy -auto-approve

apply-alb:
	cd alb && terraform init && terraform apply -auto-approve
destroy-alb:
	cd alb && terraform init && terraform destroy -auto-approve

apply-cluster:
	cd cluster && terraform init && terraform apply -auto-approve
destroy-cluster:
	cd cluster && terraform init && terraform destroy -auto-approve

apply-ec2:
	cd ec2 && terraform init && terraform apply -auto-approve
destroy-ec2:
	cd ec2 && terraform init && terraform destroy -auto-approve

apply-task:
	cd task-definition && terraform init && terraform apply -auto-approve
destroy-task:
	cd task-definition && terraform init && terraform destroy -auto-approve

apply-service:
	cd service && terraform init && terraform apply -auto-approve
destroy-service:
	cd service && terraform init && terraform destroy -auto-approve
