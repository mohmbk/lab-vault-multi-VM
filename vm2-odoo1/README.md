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
