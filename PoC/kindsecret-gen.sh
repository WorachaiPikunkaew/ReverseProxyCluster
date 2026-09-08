#!/bin/sh
cd "$(dirname "$0")"
kubectl create secret generic proxy-certs \
  --namespace mtls-proxy \
  --from-file=proxy.crt=./certs/proxy.crt \
  --from-file=proxy.key=./certs/proxy.key \
  --from-file=ca.crt=./certs/ca.crt \
  --from-file=client.crt=./certs/client.crt \
  --from-file=client.key=./certs/client.key \
  --dry-run=client -o yaml > 01-secret-certs.yaml
