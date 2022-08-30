image = versus-backend
account = $(shell aws sts get-caller-identity --query "Account" --output text)
region = us-east-1
stage = dev
include stage-configs/$(stage)

build: secret
	docker build -t $(image):$(version) .

login: 
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com

push: login
	docker tag $(image):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(image):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(image):$(version)

deploy: ingress
	cat deploy.yaml | sed "s/IMAGE_VERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) apply -f -

namespace: 
	cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f -

secret:
	echo "secret=$(dbsecret)" > ./main/.env
	echo "region=$(region)" >> ./main/.env
	cat ./main/.env
	

context:
	aws eks update-kubeconfig --region $(region) --name $(cluster)


ingress: namespace
	cat ingress.yaml | sed "s/STAGE/$(stage)/g" | kubectl -n $(namespace) apply -f -

serviceaccount:  #only run once per namespace
	eksctl create iamserviceaccount --name backend-deployment-sa --region="$(region)" --cluster "$(cluster)" --attach-policy-arn "$(policy)" --approve --override-existing-serviceaccounts --namespace=$(namespace)