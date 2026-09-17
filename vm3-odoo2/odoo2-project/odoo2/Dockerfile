FROM odoo:19

USER root

RUN apt-get update \
    && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://releases.hashicorp.com/vault/1.17.0/vault_1.17.0_linux_amd64.zip -o /tmp/vault.zip \
    && unzip /tmp/vault.zip -d /usr/local/bin \
    && rm /tmp/vault.zip

RUN mv /entrypoint.sh /odoo-entrypoint.sh

COPY entrypoint-vault.sh /entrypoint-vault.sh

RUN chmod +x /entrypoint-vault.sh

ENTRYPOINT ["/entrypoint-vault.sh"]
CMD ["odoo"]