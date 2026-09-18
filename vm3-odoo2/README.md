# VM3 — Odoo2 + PostgreSQL2

## Informations

* IP : `192.168.30.12`
* Odoo : `19.0`
* PostgreSQL : `18`
* Odoo Port : `8069`

## Rôle

Cette VM héberge la deuxième instance Odoo et sa base PostgreSQL.

```text
Odoo2
  |
  v
PostgreSQL2
```

## Vault

Les identifiants PostgreSQL sont récupérés depuis :

```text
secret/database/odoo2
```

Vault :

```text
192.168.30.10:8200
```
