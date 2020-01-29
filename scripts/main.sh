screen -dmS server vault server -config /home/user/vault/etc/config.hcl

export VAULT_ADDR=https://localhost:44300

vault operator init -t 1 -n 1
