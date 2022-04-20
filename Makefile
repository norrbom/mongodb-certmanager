SHELL := /bin/bash

MONGO_VERSION ?= v0.7.3
MONGO_GIT_REPO ?= https://github.com/mongodb/mongodb-kubernetes-operator.git

MONGO_HELM_REPO ?= https://mongodb.github.io/helm-charts
CERTM_HELM_REPO ?= https://charts.jetstack.io

git-clone:
	@[ -d mongodb-kubernetes-operator ] || git clone --depth 1 --branch $(MONGO_VERSION) $(MONGO_GIT_REPO) || true

kind-up:
	@kind get clusters | grep mongodb || kind create cluster --config=kind/config.yaml --wait 5m
	kubectl cluster-info --context kind-mongodb
	kind export kubeconfig --name mongodb

install-mongodb-kustomize: git-clone
	kustomize build overlays/kind
	kubectl apply -k overlays/kind

install-kind: kind-up intall-certm install-mongodb


intall-certm:
	@helm repo list | grep $(CERTM_HELM_REPO) || helm repo add jetstack $(CERTM_HELM_REPO)
	helm install \
	cert-manager jetstack/cert-manager \
	--namespace cert-manager \
	--create-namespace \
	--version v1.8.0 \
	--set installCRDs=true

install-mongodb:
	@helm repo list | grep $(MONGO_HELM_REPO) || helm repo add mongodb $(MONGO_HELM_REPO)
	helm -f values.yaml --namespace mongodb upgrade --install --create-namespace community-operator mongodb/community-operator --version $(MONGO_VERSION)
	
uninstall-helm:
	helm uninstall --namespace mongodb community-operator

deploy:
	kubectl apply -f samples/mongodb.yaml --namespace mongodb

cleanup:
	rm -fr mongodb-kubernetes-operator
	kind delete clusters mongodb

smoketest:
	kubectl --namespace mongodb delete pod mongoclient > /dev/null 2>&1 || true
	kubectl run mongoclient --namespace mongodb \
	--stdin --tty --rm --restart=Never \
	--image=docker.io/mongo:5.0.6 \
	--command -- mongo -u admin -p verysecret --eval "db" --host mongodb-svc:27017
	