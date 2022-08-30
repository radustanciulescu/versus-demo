image = versus-frontend
account = $(shell aws sts get-caller-identity --query "Account" --output text)
region = us-east-1
stage = dev
include stage-configs/$(stage)

reactapi:
	echo "REACT_APP_API_URL=http://versus-$(stage)-api-22acentos.exchangeweb.net" > .env.production
	cat .env.production
	sleep 5
build: reactapi
	docker build -t $(image):$(version) .

login:
	aws ecr get-login-password --region $(region) | \
		docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com


push: login
	docker tag $(image):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(image):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(image):$(version)

deploy: ingress
	cat deploy.yaml | sed "s/IMAGE_VERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) apply -f -

namespace:
	cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f -

ingress: namespace
	cat ingress.yaml | sed "s/STAGE/$(stage)/g" | kubectl -n $(namespace) apply -f -

context:
	#aws sts assume-role --role-arn "$(role)" --role-session-name AWSCLI-Session
	aws eks update-kubeconfig --region $(region) --name $(cluster)

