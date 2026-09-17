# VM1 — Vault

## Informations

* IP : `192.168.30.10`
* Service : HashiCorp Vault
* Port : `8200`

## Rôle

Cette VM héberge Vault, qui centralise les identifiants PostgreSQL des deux instances Odoo.

## Secrets

```text
secret/database/odoo1 → Identifiants PostgreSQL1
secret/database/odoo2 → Identifiants PostgreSQL2
```

## Architecture

```text
             Vault
        192.168.30.10
          /         \
         /           \
      Odoo1         Odoo2
```


