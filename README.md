# Integration test MongoDB Community Operator with Prometheus and Cert Manager on Kind

## Configure docker registry credentials
edit kind/secret.json

## Install MongoDB and Cert Manager on Kind
Using Helm
```
make install-kind deploy
```
Using Kustomize
```
make install-kind-kustomize deploy
```
## Smoke test MongoDB
```
make smoketest
```
## Delete the cluster
```
make cleanup
```
## Upgrade MongoDB

## Increase replica set during load

## Rotate Certificates under load