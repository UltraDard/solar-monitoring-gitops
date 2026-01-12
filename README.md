# Mon Projet Solaire (TP Jour 4)

Voici mon rendu pour le TP de monitoring solaire. J'ai tout fait comme demandé (enfin j'espère).

## Mon Architecture
C'est un schéma simple :
1. **GitHub** : Où est mon code.
2. **ArgoCD** : Le chef d'orchestre qui déploie tout sur Kubernetes.
3. **Le Simulateur** : Un petit programme Node.js qui génère des fausses données solaires.
4. **Prometheus** : Il récupère les chiffres.
5. **Grafana** : Il affiche les courbes.

J'ai mis plus de détails dans [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Comment on installe ?
Tout est expliqué dans [docs/INSTALLATION.md](docs/INSTALLATION.md).

En gros, il faut lancer ça :
```bash
# Créer le cluster
kind create cluster --name solar-monitoring

# Installer ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Lancer mon appli
# Lancer mon appli
kubectl apply -f argocd/applications.yaml

# Note: Il faut construire l'image docker avant car c'est en local
docker build -t solar-simulator:local src/solar-simulator/
kind load docker-image solar-simulator:local --name solar-monitoring
```

## Mes Métriques
J'ai coder ces métriques dans le fichier `index.js` :
- `solar_power_watts` : L'électricité qu'on produit (en Watts).
- `solar_irradiance_wm2` : Le soleil qu'on reçoit.
- `solar_panel_temperature_celsius` : La chaleur des panneaux.
- `solar_inverter_status` : Si l'onduleur est allumé (1) ou cassé (0).
- `solar_daily_revenue_euros` : L'argent qu'on gagne !

## Mes Alertes
Si ça plante, Prometheus m'envoie une alerte. J'en ai fait 5 :
1. **SensorDataLoss** : Si on perd les données.
2. **InverterDown** : Si l'onduleur est en panne.
3. **SolarPanelOverheating** : Si ça chauffe trop (> 65°C).
4. **LowProduction** : Si la production est trop faible par rapport au soleil.
5. **SLOBreach** : Si la disponibilité chute trop.

## Analyse des Coûts (FinOps)
Pour la partie sous, j'ai rempli le tableau. C'est cher le cloud !

| Composant | CPU | RAM | Stockage | Prix/mois |
|---|---|---|---|---|
| Solar Simulator | 100m | 128Mi | 0 | ~5€ |
| Prometheus | 500m | 1Gi | 10GB | ~25€ |
| Grafana | 200m | 512Mi | 2GB | ~15€ |
| AlertManager | 100m | 256Mi | 1GB | ~10€ |
| **Cluster (Gestion)** | - | - | - | ~70€ |
| **TOTAL** | | | | **~125€** |

**Mes idées pour payer moins cher :**
1. Prendre des serveurs moins puissants (car mon code est léger).
2. Éteindre le tout la nuit (il n'y a pas de soleil de toute façon !).
3. Utiliser des "Spot Instances" (des serveurs en promo qui peuvent couper).

## Si ça marche pas (Troubleshooting)
1. **Rien ne s'affiche ?** -> Vérifier si les pods tournent (`kubectl get pods`).
2. **ArgoCD est inaccessible ?** -> Vérifier le port-forward (`kubectl port-forward...`).
3. **Pas de métriques ?** -> Vérifier que le service monitor a les bons labels.
4. **Grafana demande un mot de passe ?** -> C'est `admin` / `admin` (j'ai pas changé).
5. **Le cluster est lent ?** -> Augmenter la RAM de Docker (ça consomme beaucoup Java/Node).

## Améliorations Futures
Si j'avais plus de temps, je ferais :
1. Une vraie base de données pour garder les infos plus longtemps.
2. Sécuriser les mots de passe (avec des Secrets Kubernetes).
3. Faire une interface web plus belle pour le simulateur. 
