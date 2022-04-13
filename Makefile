SHELL := /bin/bash

MONGO_VERSION ?= v0.7.3
MONGO_HELM_REPO ?= https://mongodb.github.io/helm-charts
MONGO_GIT_REPO ?= https://github.com/mongodb/mongodb-kubernetes-operator.git

git-clone:
	@[ -d mongodb-kubernetes-operator ] || git clone --depth 1 --branch $(MONGO_VERSION) $(MONGO_GIT_REPO) || true

kind-up:
	@kind get clusters | grep mongodb || kind create cluster --config=kind/config.yaml --wait 5m
	kubectl cluster-info --context kind-mongodb
	kind export kubeconfig --name mongodb

install: git-clone
	kustomize build overlays/kind
	kubectl apply -k overlays/kind

install-helm:
	@helm repo list | grep $(MONGO_HELM_REPO) || helm repo add mongodb $(MONGO_HELM_REPO)
	helm --namespace mongodb upgrade --install --create-namespace community-operator mongodb/community-operator --version $(MONGO_VERSION)
	
uninstall-helm:
	helm uninstall --namespace mongodb community-operator

deploy:
	kubectl apply -f samples/mongodb.yaml --namespace mongodb

cleanup:
	rm -fr mongodb-kubernetes-operator
	kind delete clusters mongodb