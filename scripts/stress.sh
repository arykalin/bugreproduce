#!/usr/bin/env bash
ERRORS=0
for i in {0..3000}
do
   if ! (( i % 12 )); then # refresh the policy
      vault write pki-monitor/venafi-policy/default \
         tpp_url="https://localhost:8080/" tpp_user="fake" tpp_password="fake" \
         zone="HashiCorp Vault\\Policy" trust_bundle_file="/home/user/prog/venafi/spiffe-hackaton/faketpp/server.crt"
   fi
   CN_ISSUE=issue-$(date '+%Y%m%d-%H%M').venafi.example
   CN_SIGN=sign-$(date '+%Y%m%d-%H%M').venafi.example
   vault write -field=serial_number pki-monitor/issue/tls-server common_name="${CN_ISSUE}" alt_names="${CN_ISSUE}"
   if [ $? != 0 ]; then
      ERRORS=$((ERRORS + 1))
   fi
   if ! (( i % 10 )); then # generate a new key pair
      openssl req -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout test.key -out test.req \
         -subj "/C=US/ST=Utah/L=Salt Lake City/OU=Product Management/O=Venafi Inc./CN=${CN_SIGN}" 2>/dev/null
   fi
   vault write -field=serial_number pki-monitor/sign/tls-server csr=@test.req
   if [ $? != 0 ]; then
      ERRORS=$((ERRORS + 1))
   fi
   QUEUE_SIZE=$(vault list pki-monitor/import-queue | wc -l)
   DIFF=$(($i - $QUEUE_SIZE))
   echo -e ">>> $QUEUE_SIZE in the queue, diff $DIFF, $ERRORS errors occurred so far...\n"
done

