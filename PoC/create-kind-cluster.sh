#!/bin/sh
kind create cluster --name demo --config kind-config.yaml
docker network connect demo-net demo-control-plane
kubectl cluster-info --context kind-demo
