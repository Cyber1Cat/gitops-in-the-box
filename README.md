# Gitops-in-the-box

A production-grade, local GitOps laboratory running on Kubernetes (Minikube/Docker) and managed entirely by ArgoCD via the **App-of-Apps pattern**. 

## Repository Architecture

This repository uses a declarative "Root-of-Roots" approach to isolate infrastructure, applications, and configurations:

```text
├── root-application.yaml      # Parent ArgoCD Application managing all child apps
├── argocd-apps/               # Manifests defining ArgoCD child Applications
├── apps/                      # Application code & manifests
│   └── guestbook/             # Front-end demo with liveness/readiness probes
└── system/                    # Core cluster services & infrastructure
    └── sealed-secrets/        # Bitnami Sealed Secrets for encrypted GitOps credentials
```

---

## Local Environment Management

To easily manage this cluster on macOS without locking up terminal windows with active network tunnels, add the following automation controls to your `~/.zshrc` profile.

### 1. Installation
Run `nano ~/.zshrc`, append these shortcuts to the bottom, and run `source ~/.zshrc`:

```bash
# Start cluster and launch the background tunnel
devops-on() {
  minikube start
  echo "⏳ Waiting 10 seconds for cluster networking..."
  sleep 10
  nohup minikube service argocd-server -n argocd > /dev/null 2>&1 & disown
  echo "🚀 ArgoCD background tunnel active! Safe to close this terminal."
}

# Stop cluster and clean up background tunnels
alias devops-off="pkill -f minikube && minikube stop"
```

### 2. Usage Commands
* **`devops-on`**: Provisions Minikube, synchronises states, and triggers a detached, background network tunnel for the ArgoCD UI.
* **`devops-off`**: Safely powers off the cluster node and frees up MacBook CPU/RAM resources.

---

### Retrieve ArgoCD Admin Password Safely
ArgoCD auto-generates a unique password on its first boot and saves it as a base64-encrypted cluster secret. Run this generic command to instantly decrypt it on demand (never save the output string into version control!):

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
* **Default Username:** `admin`

---

## Component Breakdown

### 🔹 App-of-Apps Pattern (`root-application.yaml`)
Blindsides manual syncing. The parent application continuously tracks the `argocd-apps/` directory, automatically applying and maintaining changes made to child manifests like `guestbook` or `sealed-secrets`.

### 🔹 Core System (`system/sealed-secrets`)
Enables strict GitOps secret management. Sensitive operational parameters (like database credentials) are safely encrypted into public `SealedSecret` manifests that can be safely pushed to public version control. 

### 🔹 Target Apps (`apps/guestbook`)
A multi-tier demonstration microservice complete with robust orchestration safety nets including containerized **liveness** and **readiness** probes to guarantee traffic routing stability.

## Core Skills Demonstrated

* **GitOps Continuous Delivery:** Advanced declarative environment management using ArgoCD.
* **Cluster Automation:** Shell-scripting for headless network tunneling and automated cluster lifecycles on macOS.
* **Cloud-Native Security:** Implementing asymmetric key encryption via Bitnami Sealed Secrets to prevent credential leakage.
* **High-Availability Design:** Orchestrating resilient deployments using containerized health probes.

