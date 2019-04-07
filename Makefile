AWS_PROFILE := badwolf-labs

WEBSITE_NAME := rnd.badwolf.correia.ninja
ALLOWED_IPS_CIDR := [\"$(shell curl -s http://checkip.amazonaws.com)/32\"]
WAIT_FOR_STACK := 120

p:
	@echo $(ALLOWED_IPS_CIDR)
full: apply _sleep spec destroy

init: _creds
	cd example && terraform init

plan: _creds init
	cd example && terraform plan --var allowed_ips_cidr=$(ALLOWED_IPS_CIDR)

apply: _creds
	cd example && terraform apply --auto-approve --var allowed_ips_cidr=$(ALLOWED_IPS_CIDR)

destroy: _creds init empty-logs-bucket
	cd example && terraform destroy --auto-approve --var allowed_ips_cidr=$(ALLOWED_IPS_CIDR)

state:
	cd example && terraform state list

spec: _creds
	cd example/test/spec && rake spec test_bucket=$(WEBSITE_NAME)

empty-logs-bucket:
	aws s3 rm --recursive s3://logs.$(WEBSITE_NAME)/

_creds:
	$(eval export AWS_PROFILE=$(AWS_PROFILE))

_sleep:
	cowsay -f mario Waiting $(WAIT_FOR_STACK) seconds, Hope the stack will be up...
	sleep $(WAIT_FOR_STACK)



