# Integration test MongoDB Community Operator with Prometheus and Cert Manager on Kind

## Configure docker registry credentials
edit kind/secret.json

## Install MongoDB on Kind
```
make install-kind deploy
```
## Delete the cluster
```
make cleanup
```
## Install Cert Manager

## Smoke test MongoDB

## Upgrade MongoDB

## Increase replica set during load

## Rotate Certificates under load