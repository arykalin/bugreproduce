
cd /home/user

#apt update


mv vault/etc/myroot.pem /etc/ssl/certs/

git clone https://github.com/Venafi/vault-pki-monitor-venafi/
cd vault-pki-monitor-venafi/
git checkout mod-tidy
env CGO_ENABLED=0  go build -ldflags '-s -w -extldflags "-static"' -a -o /home/user/vault/plugins/vault_pki_monitor_venafi

git clone https://github.com/arykalin/spiffe-hackaton
