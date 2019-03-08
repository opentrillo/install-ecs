STACK := trillo-rt
BUCKET := trillo-rt
PROFILE := trillo

VALIDATE_CMD := aws cloudformation validate-template --template-body
STACK_PARAMETERS := ParameterKey=VpcCIDR,ParameterValue=10.180.0.0/16
STACK_PARAMETERS += ParameterKey=PublicSubnet1CIDR,ParameterValue=10.180.8.0/21
STACK_PARAMETERS += ParameterKey=PublicSubnet2CIDR,ParameterValue=10.180.16.0/21
STACK_PARAMETERS += ParameterKey=PrivateSubnet1CIDR,ParameterValue=10.180.24.0/21
STACK_PARAMETERS += ParameterKey=PrivateSubnet2CIDR,ParameterValue=10.180.32.0/21
STACK_PARAMETERS += ParameterKey=DBUser,ParameterValue=trillort
STACK_PARAMETERS += ParameterKey=DBPassword,ParameterValue=tri110Rt
STACK_PARAMETERS += ParameterKey=DBAllocatedStorage,ParameterValue=5
STACK_PARAMETERS += ParameterKey=DBInstanceClass,ParameterValue=db.t2.small
STACK_PARAMETERS += ParameterKey=DBMultiAZ,ParameterValue=true
STACK_PARAMETERS += ParameterKey=EcsInstanceType,ParameterValue=m4.large
STACK_PARAMETERS += ParameterKey=EcsClusterMaxSize,ParameterValue=10
STACK_PARAMETERS += ParameterKey=EcsInstanceKeyName,ParameterValue=trillo
STACK_PARAMETERS += ParameterKey=TrilloDsDockerImageTag,ParameterValue=0.5.0-BUILD-SNAPSHOT_39
STACK_PARAMETERS += ParameterKey=TrilloDsDesiredInstanceCount,ParameterValue=2
STACK_PARAMETERS += ParameterKey=TrilloRtDockerImageTag,ParameterValue=1.0.0-BUILD-SNAPSHOT_165
STACK_PARAMETERS += ParameterKey=TrilloRtDesiredInstanceCount,ParameterValue=2
STACK_PARAMETERS += ParameterKey=EcsDockerId,ParameterValue=${TRILLO_DOCKER_ID}
STACK_PARAMETERS += ParameterKey=EcsDockerPassword,ParameterValue=${TRILLO_DOCKER_PASSWORD}

validate:
	$(VALIDATE_CMD) file://master.yaml
	$(VALIDATE_CMD) file://infrastructure/vpc.yaml
	$(VALIDATE_CMD) file://infrastructure/security-groups.yaml
	$(VALIDATE_CMD) file://infrastructure/database.yaml
	$(VALIDATE_CMD) file://infrastructure/load-balancers.yaml
	$(VALIDATE_CMD) file://infrastructure/ecs-cluster.yaml
	$(VALIDATE_CMD) file://infrastructure/bastion.yaml
	$(VALIDATE_CMD) file://services/trillo-data-service.yaml
	$(VALIDATE_CMD) file://services/trillo-rt-service.yaml
	$(VALIDATE_CMD) file://services/trillo-custom-service.yaml
	$(VALIDATE_CMD) file://services/trillo-functions-service.yaml

upload:
	aws s3 cp master.yaml s3://$(BUCKET)/master.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/vpc.yaml s3://$(BUCKET)/infrastructure/vpc.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/security-groups.yaml s3://$(BUCKET)/infrastructure/security-groups.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/database.yaml s3://$(BUCKET)/infrastructure/database.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/load-balancers.yaml s3://$(BUCKET)/infrastructure/load-balancers.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/ecs-cluster.yaml s3://$(BUCKET)/infrastructure/ecs-cluster.yaml --profile $(PROFILE)
	aws s3 cp infrastructure/bastion.yaml s3://$(BUCKET)/infrastructure/bastion.yaml --profile $(PROFILE)
	aws s3 cp services/trillo-data-service.yaml s3://$(BUCKET)/services/trillo-data-service.yaml --profile $(PROFILE)
	aws s3 cp services/trillo-rt-service.yaml s3://$(BUCKET)/services/trillo-rt-service.yaml --profile $(PROFILE)
	aws s3 cp services/trillo-custom-service.yaml s3://$(BUCKET)/services/trillo-custom-service.yaml --profile $(PROFILE)
	aws s3 cp services/trillo-functions-service.yaml s3://$(BUCKET)/services/trillo-functions-service.yaml --profile $(PROFILE)

create-stack:
	aws cloudformation create-stack --disable-rollback --template-url https://s3.us-east-2.amazonaws.com/$(BUCKET)/master.yaml \
                --stack-name $(STACK) --parameters $(STACK_PARAMETERS) \
                --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --profile $(PROFILE)
	#--disable-rollback
	aws cloudformation wait stack-create-complete --stack-name $(STACK) --profile $(PROFILE)

delete-stack:
	aws cloudformation delete-stack --stack-name $(STACK) --profile $(PROFILE)
	aws cloudformation wait stack-delete-complete --stack-name $(STACK) --profile $(PROFILE)

update-stack:
	aws cloudformation update-stack --template-url https://s3.us-east-2.amazonaws.com/$(BUCKET)/master.yaml \
                --stack-name $(STACK) --parameters $(STACK_PARAMETERS) \
                --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --profile $(PROFILE)
	aws cloudformation wait stack-update-complete --stack-name $(STACK) --profile $(PROFILE)

print-parameters:
	@echo $(STACK_PARAMETERS)