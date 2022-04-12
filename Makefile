SHELL := /bin/bash

VERSION ?= v0.7.3

git-clone:
	git clone --depth 1 --branch $(VERSION) https://github.com/mongodb/mongodb-kubernetes-operator.git

kind-up:
	kind create cluster --config=kind/config.yaml --wait 5m
	kubectl cluster-info --context kind-mongodb
	kind export kubeconfig --name mongodb

install:
	kustomize build overlays/kind
	kubectl apply -k overlays/kind

deploy:
	kubectl apply -f samples/cr.yaml --namespace mongodb

cleanup:
	rm -fr mongodb-kubernetes-operator
	kind delete clusters mongodb