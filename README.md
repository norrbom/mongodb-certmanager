# Install MongoDB Community Operator on Kind 

## Clone the Community Operator repository
```
git clone git clone --depth 1 --branch v0.7.3 https://github.com/mongodb/mongodb-kubernetes-operator.git
```

## Setup Kind
```
kind create cluster --config=kind/config.yaml --wait 5m
kubectl cluster-info --context kind-mongodb
kind export kubeconfig --name mongodb
```
## Install the Operator
```
kubectl create ns mongodb
kubectl apply -k config/rbac/ --namespace mongodb
kubectl create -f config/manager/manager.yaml --namespace mongodb
kubectl get pods --namespace mongodb
```