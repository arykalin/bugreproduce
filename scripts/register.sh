vault secrets disable pki-backend/
SHA256=$(sha256sum /home/user/vault/plugins/venafi-pki-backend | cut -d' ' -f1)
vault write sys/plugins/catalog/secret/pki-backend-venafi sha_256="${SHA256}" command="venafi-pki-backend"
vault secrets enable -path=pki-backend -description="Venafi Enrollment" -plugin-name=pki-backend-venafi plugin
vault secrets disable pki-monitor/
SHA256=$(sha256sum /home/user/vault/plugins/vault_pki_monitor_venafi | cut -d' ' -f1)
vault write sys/plugins/catalog/secret/pki-monitor-venafi sha_256="${SHA256}" command="vault_pki_monitor_venafi"
vault secrets enable -path=pki-monitor -description="Venafi Policy and Visibility" -plugin-name=pki-monitor-venafi plugin
vault secrets tune -max-lease-ttl=8760h pki-monitor
vault write pki-monitor/venafi-policy/default \
  tpp_url="https://localhost:8080/" tpp_user="local:carla" tpp_password="newPassw0rd!" \
  zone="HashiCorp Vault\\Policy" trust_bundle_file="/home/user/prog/venafi/spiffe-hackaton/faketpp/server.crt"
vault write pki-monitor/roles/tls-server generate_lease=true ttl=24h \
  max_ttl=8760h key_type="ec" key_bits=256 allow_any_name=true \
  organization="Venafi Inc." ou="Product Management" locality="Salt Lake City" \
  province="Utah" country="US" tpp_import=true tpp_url="https://localhost:8080/" \
  tpp_user="local:carla" tpp_password="newPassw0rd!" \
  zone="HashiCorp Vault\\Visibility" trust_bundle_file="/home/user/prog/venafi/spiffe-hackaton/faketpp/server.crt"
vault write pki-monitor/root/generate/internal \
  ttl=2160h key_bits=256 key_type=ec exclude_cn_from_sans=true \
  common_name="Venafi Monitored Issuing CA" organization="Venafi Inc." \
  locality="Salt Lake City" province="Utah" country="US" 
vault write pki-monitor/config/urls \
  issuing_certificates="https://rtreat-linux.venqa.venafi.com:44300/v1/pki-monitor/ca" \
  crl_distribution_points="https://rtreat-linux.venqa.venafi.com:44300/v1/pki-monitor/crl"

rm -f ca-monitor.*
