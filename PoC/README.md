## PoC : Nginx reverse proxy on kind

 1. `generate-certs.sh`  generate certs for every hosts.
 3. `docker compose up -d` up 2 backend hosts.
 4. `create-kind-cluster.sh` create cluster with kind.
 5. `kindsecret-gen.sh` gen certs secret manifest.
 6. `kinddeployment-gen.sh` gen deployment with static backend hosts IP.
 7. `apply-manifest.sh` apply all manifest
 ## Testing with

    curl -k --resolve web1.example.net:8443:127.0.0.1 https://web1.example.net:8443/

    curl -k --resolve web2.example.net:8443:127.0.0.1 https://web2.example.net:8443/

    kubectl -n mtls-proxy logs -l app=nginx-proxy --prefix -f

