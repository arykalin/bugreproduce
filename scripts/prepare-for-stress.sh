#!/usr/bin/env bash
vault secrets tune -max-lease-ttl=8760h pki
vault write pki/venafi-policy/default \
  tpp_url="https://tpp:8080/" tpp_user="local:carla" tpp_password="newPassw0rd!" \
  zone="HashiCorp Vault\\Policy" trust_bundle_file="/opt/venafi/bundle.pem"
vault write pki/roles/tls-server generate_lease=true ttl=24h \
  max_ttl=8760h key_type="ec" key_bits=256 allow_any_name=true \
  organization="Venafi Inc." ou="Product Management" locality="Salt Lake City" \
  province="Utah" country="US" tpp_import=true tpp_url="https://tpp:8080/" \
  tpp_user="local:carla" tpp_password="newPassw0rd!" \
  zone="HashiCorp Vault\\Visibility" trust_bundle_file="/opt/venafi/bundle.pem"
vault write pki/root/generate/internal \
  ttl=2160h key_bits=256 key_type=ec exclude_cn_from_sans=true \
  common_name="Venafi Monitored Issuing CA" organization="Venafi Inc." \
  locality="Salt Lake City" province="Utah" country="US"
vault write pki/config/urls \
  issuing_certificates="https://tpp:8080/v1/pki/ca" \
  crl_distribution_points="https://tpp:8080/v1/pki/crl"
