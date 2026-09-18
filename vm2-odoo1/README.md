# VM2 — Odoo1 + PostgreSQL1

## Informations

* IP : `192.168.30.11`
* Odoo : `13.0`
* PostgreSQL : `10`
* Odoo Port : `8069`

## Rôle

Cette VM héberge la première instance Odoo et sa base PostgreSQL.

```text
Odoo1
  |
  v
PostgreSQL1
```

## Vault

Les identifiants PostgreSQL sont récupérés depuis :

```text
secret/database/odoo1
```

Vault :

```text
192.168.30.10:8200
```


## Redémarrage du conteneur Vault

Le conteneur Vault est lancé via `docker run` (pas de `docker-compose.yml`
sur cette VM — un seul conteneur ne justifie pas Docker Compose).

### Si la VM redémarre (Power Off / Start)

Le conteneur `vault` reste enregistré dans Docker mais s'arrête avec la VM.
Il ne faut **pas** relancer la commande `docker run` complète — il suffit
de redémarrer le conteneur existant :

```bash
sudo docker start vault
```

### Si le conteneur a été supprimé (`docker rm vault`)

Dans ce cas, il faut relancer la commande complète :

```bash
sudo docker run -d \
  --name vault \
  --restart unless-stopped \
  --cap-add=IPC_LOCK \
  -p 8200:8200 \
  -v ~/vault/config:/vault/config \
  -v ~/vault/data:/vault/data \
  hashicorp/vault:1.17 \
  server
```