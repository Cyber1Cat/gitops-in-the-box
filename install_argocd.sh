#!/bin/bash
helm repo add argo https://github.io
helm repo update
helm install argocd argo/argo-cd --namespace argocd
