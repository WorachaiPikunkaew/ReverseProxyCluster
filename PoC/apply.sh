#!/bin/sh
kubectl apply -f 00-namespace.yaml
kubectl apply -f 01-secret-certs.yaml
kubectl apply -f 02-configmap-nginx.yaml
kubectl apply -f 03-deployment.yaml
kubectl apply -f 04-service.yaml

kubectl -n mtls-proxy get pods -o wide
kubectl -n mtls-proxy get svc
