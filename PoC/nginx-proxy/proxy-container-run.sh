#!/bin/sh
docker run -d --name nginx-proxy --network mtls-net -p 80:80 -p 443:443 \
-v $(dirname "$0")/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
-v $(dirname "$0")/../certs:/etc/nginx/certs:ro \
nginx:stable
