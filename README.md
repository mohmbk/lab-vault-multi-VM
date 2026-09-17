# SIG SERVICE — Secure Secret Management Lab

Laboratoire de mise en place d'une architecture sécurisée pour la gestion des secrets d'une infrastructure ERP basée sur **Odoo**, **PostgreSQL** et **HashiCorp Vault**.

L'objectif principal est d'éviter de stocker les identifiants sensibles directement dans les fichiers de configuration, le code source ou le dépôt Git.

---

## Architecture

Le laboratoire est composé de trois machines virtuelles Ubuntu connectées sur un réseau privé :

| VM  | Adresse IP      | Rôle                  |
| --- | --------------- | --------------------- |
| VM1 | `192.168.30.10` | HashiCorp Vault       |
| VM2 | `192.168.30.11` | Odoo 1 + PostgreSQL 1 |
| VM3 | `192.168.30.12` | Odoo 2 + PostgreSQL 2 |

### Vue générale

```text
                         Réseau privé
                     192.168.30.0/24
                              |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
   +-------------+     +---------------+   +---------------+
   |    VM1      |     |     VM2       |   |     VM3       |
   |    Vault    |     |    Odoo 1     |   |    Odoo 2     |
   |192.168.30.10|     | PostgreSQL 1  |   | PostgreSQL 2  |
   +-------------+     |192.168.30.11  |   |192.168.30.12  |
                       +---------------+   +---------------+
                              |                   |
                              +---------+---------+
                                        |
                                  Secrets depuis
                                      Vault
```

---

## Technologies utilisées

* Ubuntu Server
* Docker
* Docker Compose
* HashiCorp Vault
* Odoo
* PostgreSQL
* Git / GitHub

---

## Objectifs du laboratoire

Ce laboratoire permet de mettre en pratique plusieurs principes de sécurité :

* Centralisation des secrets avec Vault
* Suppression des mots de passe sensibles du code source
* Séparation des environnements et des services
* Communication entre Odoo et Vault
* Récupération des identifiants PostgreSQL depuis Vault
* Utilisation de Docker pour isoler les services
* Protection des secrets contre leur exposition dans Git
* Préparation d'une architecture pouvant être adaptée à un environnement de production

---

## Gestion des secrets

Les identifiants PostgreSQL ne doivent pas être écrits directement dans le dépôt Git.

Le principe utilisé est :

```text
                    +----------------+
                    |      Vault     |
                    |                |
                    | PostgreSQL     |
                    | credentials    |
                    +-------+--------+
                            |
                            | Secret
                            v
                    +---------------+
                    |     Odoo      |
                    |               |
                    | Entrypoint    |
                    +-------+-------+
                            |
                            v
                    +---------------+
                    |  PostgreSQL   |
                    +---------------+
```

Au démarrage du conteneur Odoo :

1. Odoo récupère le token Vault fourni de manière sécurisée.
2. L'entrypoint contacte Vault.
3. Les credentials PostgreSQL sont récupérés.
4. Les informations nécessaires sont utilisées pour configurer la connexion.
5. Odoo démarre.

Les secrets réels ne doivent jamais être commités dans Git.

---

## Structure du projet

Une structure possible du projet est :

```text
lab-sig-service/
│
├── README.md
├── .gitignore
│
├── vault/
│   └── config/
│       └── vault.hcl
│
├── odoo1-project/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── entrypoint.sh
│   ├── odoo.conf
│   └── secrets/
│       └── vault_token
│
└── odoo2-project/
    ├── Dockerfile
    ├── docker-compose.yml
    ├── entrypoint.sh
    ├── odoo.conf
    └── secrets/
        └── vault_token
```

> Les fichiers contenant des tokens, mots de passe ou autres informations sensibles doivent être exclus du dépôt.

---

## Configuration de Vault

Vault est utilisé comme gestionnaire centralisé des secrets.

Exemple de données stockées :

```text
secret/
└── odoo1/
    ├── postgres_user
    └── postgres_password

secret/
└── odoo2/
    ├── postgres_user
    └── postgres_password
```

Les valeurs réelles ne doivent pas apparaître dans ce README.

---

## Odoo 1

Odoo 1 est exécuté sur :

```text
VM : 192.168.30.11
```

Services principaux :

```text
odoo1
postgres1
```

Odoo communique avec PostgreSQL via le réseau Docker interne.

---

## Odoo 2

Odoo 2 est exécuté sur :

```text
VM : 192.168.30.12
```

Services principaux :

```text
odoo2
postgres2
```

Cette VM permet également de tester l'utilisation d'une version plus récente d'Odoo et de PostgreSQL.

---

## Réseau

Les différentes machines virtuelles communiquent via un réseau privé :

```text
192.168.30.0/24
```

Adresses utilisées :

```text
Vault      → 192.168.30.10
Odoo 1     → 192.168.30.11
Odoo 2     → 192.168.30.12
```

Les communications entre les conteneurs Docker utilisent également des réseaux Docker internes.

---

## Démarrage

### 1. Démarrer Vault

Sur la VM Vault :

```bash
cd ~/vault
sudo docker compose up -d
```

Vérifier le conteneur :

```bash
sudo docker ps
```

Vérifier les logs :

```bash
sudo docker logs vault
```

---

### 2. Démarrer Odoo 1

Sur la VM Odoo 1 :

```bash
cd ~/odoo1-project
sudo docker compose up -d
```

Vérifier les conteneurs :

```bash
sudo docker ps
```

Consulter les logs :

```bash
sudo docker logs odoo1
```

---

### 3. Démarrer Odoo 2

Sur la VM Odoo 2 :

```bash
cd ~/odoo2-project
sudo docker compose up -d
```

Vérifier les conteneurs :

```bash
sudo docker ps
```

Consulter les logs :

```bash
sudo docker logs odoo2
```

---

## Vérification de PostgreSQL

Pour vérifier les bases de données PostgreSQL :

```bash
sudo docker exec -it postgres1 psql -U admin1 -l
```

Pour PostgreSQL 2 :

```bash
sudo docker exec -it postgres2 psql -U admin2 -l
```

Les commandes exactes peuvent varier selon les credentials configurés dans Vault.

---

## Sécurité

### Ne jamais committer

Les éléments suivants ne doivent jamais être envoyés sur Git :

* Tokens Vault
* Mots de passe PostgreSQL
* Clés privées
* Fichiers `.env` contenant des secrets
* Fichiers de credentials
* Tokens API
* Certificats privés

Les secrets doivent être stockés dans Vault ou dans un mécanisme sécurisé adapté à l'environnement.

---

## Vérification avant un commit

Avant de pousser les modifications :

```bash
git status
```

Vérifier les fichiers qui seront ajoutés :

```bash
git diff --cached
```

Puis :

```bash
git add .
git status
```

et seulement après :

```bash
git commit -m "Update lab configuration"
git push
```

---

## Avert
