SHELL := /bin/bash

VERSION ?= v0.7.3

git-clone:
	@[ -d mongodb-kubernetes-operator ] || git clone --depth 1 --branch $(VERSION) https://github.com/mongodb/mongodb-kubernetes-operator.git || true

kind-up:
	@kind get clusters | grep mongodb || kind create cluster --config=kind/config.yaml --wait 5m
	kubectl cluster-info --context kind-mongodb
	kind export kubeconfig --name mongodb

install: git-clone
	kustomize build overlays/kind
	kubectl apply -k overlays/kind

install-helm:
	@helm repo list | grep "https://mongodb.github.io/helm-charts" || helm repo add mongodb https://mongodb.github.io/helm-charts
	helm --namespace mongodb upgrade --install --create-namespace community-operator mongodb/community-operator --version $(VERSION)

uninstall-helm:
	helm uninstall --namespace mongodb community-operator

deploy:
	kubectl apply -f samples/cr.yaml --namespace mongodb

cleanup:
	rm -fr mongodb-kubernetes-operator
	kind delete clusters mongodb