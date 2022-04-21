#!/bin/bash

if [ -n "$DOCKER_USER" ] && [ -n "$DOCKER_PASSWORD" ]
then
AUTH=$(echo -ne "$DOCKER_USER:$DOCKER_PASSWORD" | base64)
cat > kind/secret.json <<EOL
{
    "auths": {
        "https://index.docker.io/v1/": {
        "auth": "${AUTH}"
        }
    }
}
EOL
cat > kind/config.yaml <<EOL
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: mongodb
nodes:
- role: control-plane
  extraMounts:
  - containerPath: /var/lib/kubelet/config.json
    hostPath: ${PWD}kind/secret.json
- role: worker
  extraMounts:
  - containerPath: /var/lib/kubelet/config.json
    hostPath: ${PWD}kind/secret.json
- role: worker
  extraMounts:
  - containerPath: /var/lib/kubelet/config.json
    hostPath: ${PWD}kind/secret.json
- role: worker
  extraMounts:
  - containerPath: /var/lib/kubelet/config.json
    hostPath: ${PWD}kind/secret.json
EOL
else
cat > kind/config.yaml <<EOL
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: mongodb
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
EOL
fi