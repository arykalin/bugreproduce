To reproduce the bug run:  
1. `make docker_server`  
    It will prepare Vault with Consul backend and TPP mock server.  
    You will be asked to enter unsel and root tokens which you will see in console.

1. Export VAULT_TOKEN and VAULT_ADDR variables  
    ```
    export VAULT_TOKEN=<root token you previously enterd>
    export VAULT_ADDR=http://127.0.0.1:8200
    ``` 

1. `make reproduce_humana_bag`    
    It will configure vault-pki-monitor-venafi plugin backend and 
    start stress script which will reproduce the bug.
      
