#!/bin/bash

set -e

export VAULT_ADDR="http://192.168.30.10:8200"
export VAULT_TOKEN=$(cat /run/secrets/vault_token)

echo "======================================"
echo "  Récupération des secrets depuis Vault"
echo "======================================"

DB_USER=$(vault kv get -field=username secret/database/odoo2)
DB_PASSWORD=$(vault kv get -field=password secret/database/odoo2)

if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Erreur : impossible de récupérer les identifiants PostgreSQL depuis Vault."
    exit 1
fi

export USER="$DB_USER"
export PASSWORD="$DB_PASSWORD"

echo "Identifiants PostgreSQL récupérés depuis Vault."

exec /odoo-entrypoint.sh "$@"