# Guide d'Installation

## Prérequis
- **Docker** : Pour conteneuriser le simulateur.
- **Kind** (Kubernetes in Docker) ou **Minikube** : Pour le cluster local.
- **Kubectl** : CLI Kubernetes.
- **ArgoCD CLI** (Optionnel mais recommandé).

## 1. Démarrer le Cluster
Créer un cluster avec Kind :
```bash
kind create cluster --name solar-monitoring
```

## 2. Installer ArgoCD
Déployer ArgoCD dans le namespace `argocd` :
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Attendre que les pods soient prêts :
```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
```

## 3. Construire et Charger l'Image
Comme nous sommes en local avec Kind, il faut charger l'image Docker directement dans le cluster :
```bash
# Construire l'image
docker build -t solar-simulator:local src/solar-simulator/

# Charger dans Kind
kind load docker-image solar-simulator:local --name solar-monitoring
```

## 4. Déployer l'Application
Appliquer les définitions d'application ArgoCD :
```bash
kubectl apply -f argocd/applications.yaml
```

*Note : Assurez-vous d'avoir mis à jour l'URL du repository Git dans `argocd/applications.yaml` avant de lancer la commande.*

## 5. Accéder aux Interfaces

### ArgoCD
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
> URL : https://localhost:8080
> User : admin
> Password : `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

### Grafana
```bash
kubectl port-forward svc/grafana 3000:3000
```
> URL : http://localhost:3000
> User : admin
> Password : admin
