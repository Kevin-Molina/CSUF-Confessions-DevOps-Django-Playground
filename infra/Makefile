vpc: init-vpc plan-vpc apply-vpc
init-vpc:
	cd vpc; terraform init
plan-vpc:
	cd vpc; terraform plan
apply-vpc:
	cd vpc; terraform apply
destroy-vpc:
	cd vpc; terraform destroy

iam: init-iam plan-iam apply-iam
init-iam:
	cd iam; terraform init
plan-iam:
	cd iam; terraform plan
apply-iam:
	cd iam; terraform apply
destroy-iam:
	cd iam; terraform destroy

sgs: init-sgs plan-sgs apply-sgs
init-sgs:
	cd security-groups; terraform init
plan-sgs:
	cd security-groups; terraform plan
apply-sgs:
	cd security-groups; terraform apply
destroy-sgs:
	cd security-groups; terraform destroy

alb: init-alb plan-alb apply-alb
init-alb:
	cd alb; terraform init
plan-alb:
	cd alb; terraform plan
apply-alb:
	cd alb; terraform apply
destroy-alb:
	cd alb; terraform destroy

cluster: init-cluster plan-cluster apply-cluster
init-cluster:
	cd cluster; terraform init
plan-cluster:
	cd cluster; terraform plan
apply-cluster:
	cd cluster; terraform apply
destroy-cluster:
	cd cluster; terraform destroy