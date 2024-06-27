# Karist

Karist est une manière plus simple de configurer et déployer ses applications sur Kubernetes. Plus concrètement :

* Aucun CRD requis dans vos clusters Kubernetes
* Support natif d'une infinité d'environnement
* Structure opiniatée de repository Git
* Implémentation de fonctions muables
* Une CLI pour initialiser, prédire et appliquer les changements

Il peut être comparé avec **Helm**, bien que plus limité dans ses fonctions.

## Installation

Karist dépend entièrement de Ruby (> 3.0) car il est construit avec, mais aucune connaissance de Ruby n'est nécessaire pour utiliser cette application.

```bash
gem install karist
```

## Quick start

### Concepts

Karist s'article autour des opinions suivants:

* Un fichier YAML ne doit contenir que du YAML
* Les environnements concernent des valeurs parfois communes, parfois différentes
* Un déploiement Kubernetes a besoin de plusieurs manifests (Deployment, Service, Ingress, ServiceAccount...), tous doivent être liés
* L'utilisation des fonctions natives de Kubernetes doit être mis en avant

Le lexique suivant s'applique à Karist:

* `template`: un template est un dossier contenant plusieurs manifests Kubernetes. Un bon manifest doit pouvoir être modifié aisément par injection de variables.
* `customization`: une customization est l'application de variables à un manifest Kubernetes appartant à un template.
* `release`: une release est l'instantiation d'un template en accord avec des customizations appliquées à ses manifests.
* `environment`: un environnement possède une ou plusieurs releases, qui sont des templates adaptés au contexte de l'environnement.

```bash
karist --init .
```

Crée une structure initiale dans le répertoire courant, directement utilisable.

```
.
├── templates
│   ├── stateless-app
│   │   ├── karist.yml
│   │   └── manifests
│   │       ├── deployment.yml
│   │       ├── service.yml
│   │       └── serviceaccount.yml
│   └── yourapp
├── environments
│   ├── development
│   │   ├── releases.yml
│   │   └── nginx
│   │       └── custom.yml
│   ├── local
│   └── production
└── karist.yml
```

Le fichier releases.yml indique par défaut ceci:

```
releases:
  - name: nginx
    namespace: default
    template: stateless-app
```

Lors de l'exécution de la commande suivante :

```bash
karist --render --env development
```

Karist va automatiquement utiliser les manifests de `stateless-app` et charger les variables définies dans le fichier `custom.yml`.

## Variables et fonctions

Helm utilise un moteur de langage qui rend selon moi la lecture de fichiers YAML complexe. En créant Karist, j'ai préféré mettre en avant la simplicité de YAML en implémentant une logique **au niveau des valeurs** des types standards.
Ainsi, des fonctions (toujours préfixées par _) sont utilisables auprès des manifests:

```
# templates/stateless-app/manifests/deployment.yml
yaml
apiVersion: v1
metadata:
  name: _-> release.name
  labels:
    _merge: release.labels
    karist/template-name: stateless-app
```

```yaml
# environments/development/nginx/custom.yml
release:
  name: nginx
  labels:
    key: value
```

Lors de l'évaluation du manifest, Karist remplace les fonctions par une évaluation. 

```yaml
# karist --dry-render \
#   ./templates/stateless-app/manifests/deployment.yml
#   ./environments/development/nginx/custom.yml

apiVersion: v1
metadata:
  name: nginx
  labels:
    karist/template-name: stateless-app
    key: value
```
