disable_cache = true
disable_mlock = true
ui = true
listener "tcp" {
  address = "0.0.0.0:44300"
  tls_disable = false
  tls_cert_file = "/home/user/vault/etc/cert.pem"
  tls_key_file = "/home/user/vault/etc/key.pem"
}
storage "file" {
  path = "/home/user/vault/data"
}
api_addr = "https://localhost:44300"
max_lease_ttl = "8760h"
default_lease_ttl = "2160h"
plugin_directory = "/home/user/vault/plugins"
tls_disable_client_certs = true
log_level="Trace"
