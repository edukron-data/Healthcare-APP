# Sr. DevOps Take-Home — Minimal Submission

This repository contains a minimal FastAPI app and scaffolding to deploy it to Azure AKS with Terraform, Helm, ACR, Key Vault, and CI/CD.

**Architecture (Azure)**

```mermaid
graph LR
  A[User] --> LB[Ingress (NGINX)]
  LB --> AKS[AKS Cluster]
  AKS -->|CSI Key Vault| KV[Azure Key Vault]
  AKS -->|VNet| PG[Azure PostgreSQL Flexible Server (private)]
  AKS --> ACR[Azure Container Registry]

```

Quick start (local)

1. Build and run locally:

```bash
# Full local stack using Docker Compose (app + Postgres)
docker compose up --build
```

2. Open http://localhost:8000/health

What I scaffolded so far

- `main.py` — FastAPI app with `/health`, `/login`, `/dashboard`, `/appointments`, `/patients`
- `Dockerfile`, `requirements.txt`
- `terraform/azure/` — Terraform root + modules under `terraform/modules/` for Azure (network, aks, postgres, keyvault, acr)
- `charts/healthcare-app/` — Helm chart with probes, HPA, NetworkPolicy, CSI SecretProviderClass template
- `azure-pipelines.yml` — Azure DevOps pipeline with terraform, Helm deploy, OIDC-friendly Azure login, security scans, manual approval
- `scripts/create_azure_devops_pipeline.sh` — Azure CLI script to create the pipeline in Azure DevOps
- `scripts/ai_pr_review.py` — example AI-assisted PR review script

Next steps (recommended)

- Populate `terraform/azure/` variables and backend values and run `terraform init`/`plan`.
- Configure Azure AD federated credentials for GitHub OIDC and set the `AZURE_*` secrets used in the workflow or configure OIDC-based service principal.
- Install cert-manager + ingress-nginx in AKS, configure `ClusterIssuer` for Let's Encrypt.

AKS / Helm / CSI quick deploy

1. Ensure AKS has the Secrets Store CSI driver and the Azure Key Vault provider installed. See the provider docs for setup.

2. Create a Kubernetes namespace and install the Helm chart (example):

```bash
kubectl create namespace healthcare
helm upgrade --install healthcare ./charts/healthcare-app --namespace healthcare \
  --set image.repository=myacr.azurecr.io/healthcare-app --set image.tag=<TAG>
```

3. ServiceAccount & Workload Identity (example values):

Set `serviceAccount.annotations` in the chart values to include your Azure AD federated client id, for example:

```yaml
serviceAccount:
  create: true
  annotations:
    azure.workload.identity/client-id: "<AZURE_AD_APP_CLIENT_ID>"
```

This ties pods to an Azure AD identity (Workload Identity) which the Key Vault CSI provider will use to fetch secrets. Replace `<AZURE_AD_APP_CLIENT_ID>` with your AAD application's client id and configure the federated credential in Azure AD.

4. Install cert-manager and ingress-nginx (example):

```bash
# cert-manager
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.15.0 --set installCRDs=true

# ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# apply ClusterIssuer (staging)
kubectl apply -f k8s/cluster-issuer.yaml
```

Notes on CSI and secrets
- The chart includes a `SecretProviderClass` that maps an Azure Key Vault secret (OBJECT) into a Kubernetes secret `db-credentials`. The `Deployment` reads the `DATABASE_URL` from that K8s secret.
- For production, configure Azure Workload Identity and ensure the AKS cluster and Azure AD app have the federated credential configured. Do NOT store service principal secrets in Git.

Local full-stack

After `docker compose up --build`:

- App: http://localhost:8000/
- Health: http://localhost:8000/health
- Patients endpoint: http://localhost:8000/patients
 - Login: `admin / P@ssw0rd!`
 
 The app now includes a production-style healthcare dashboard with a secure login screen, KPI cards, appointment widget, and patient registry table.
