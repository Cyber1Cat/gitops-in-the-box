# 📦 Gitops-in-the-box

<p align="center">
  <img src="https://shields.io" alt="Kubernetes">
  <img src="https://shields.io" alt="ArgoCD">
  <img src="https://shields.io" alt="Sealed Secrets">
  <img src="https://shields.io" alt="macOS">
</p>

A production-grade, local GitOps laboratory built to mirror enterprise cloud environments. This repository implements a fully automated cluster ecosystem managed entirely by ArgoCD via the **App-of-Apps design pattern**.

## 🎯 The Mission
Most local environments suffer from "configuration drift" and messy terminal windows. **gitops-in-the-box** solves this by enforcing absolute declarative state control and automating local network routing, letting engineers focus on shipping code rather than managing local infrastructure infrastructure.

---

## 🗺️ Repository Architecture

This ecosystem utilizes a strict **"Root-of-Roots"** topology to isolate core infrastructure, applications, and orchestration controls:

```text
├── root-application.yaml      # The Parent ArgoCD App (The single source of truth)
├── argocd-apps/               # Declarative manifests defining child applications
├── apps/                      # Application layer
│   └── guestbook/             # Multi-tier frontend showcasing container health probes
└── system/                    # Cluster-wide infrastructure services
    └── sealed-secrets/        # Bitnami Sealed Secrets for zero-trust GitOps credentials
```

---

## 🚀 Headless Local Automation (MacOS)

Tired of leaving terminal tabs open just to keep local cluster connections alive? These custom automations keep your focus inside the browser while managing Mac memory resources efficiently.

### 1. Injection Setup
Append these shortcuts to the bottom of your terminal profile (`~/.zshrc`) and refresh via `source ~/.zshrc`:

```bash
# Boot the laboratory & run background network tunnels silently
devops-on() {
  minikube start
  echo "⏳ Warming up cluster networking..."
  sleep 10
  nohup minikube service argocd-server -n argocd > /dev/null 2>&1 & disown
  echo "🚀 ArgoCD background tunnel active! Safe to close this terminal."
}

# Instant teardown to reclaim MacBook CPU/RAM
alias devops-off="pkill -f minikube && minikube stop"
```

### 2. Operational Flow
* Run **`devops-on`** to provision the cluster and background the UI tunnel. Close the window immediately.
* Run **`devops-off`** when your shift ends to completely freeze cluster nodes and restore local RAM.

---

## ⚡ The GitOps Power-User Toolkit

### 🔑 Zero-Leakage Credential Recovery
ArgoCD generates an automated administrative tracking string on first boot. Pull and decrypt it dynamically on demand without ever hardcoding secrets into your codebase:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
* 👤 **Default User:** `admin`

---

## 🛠️ Production Concepts Demonstrated

* 🔄 **GitOps Continuous Delivery:** Advanced declarative reconciliation using nested state tracking.
* 🔐 **Zero-Trust Security:** Asymmetric key encryption utilizing `kubeseal` to safely commit encrypted artifacts directly to public source control.
* 🩺 **High-Availability Design:** Fail-safe pod orchestration built with robust **liveness** and **readiness** probes to eliminate service downtimes.
* 💻 **Developer Experience (DX):** Custom shell-level tooling engineered to optimize machine resource scheduling and interface clutter.

