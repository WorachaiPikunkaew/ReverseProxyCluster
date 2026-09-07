#!/bin/sh
set -e
cd "$(dirname "$0")"

# ---- 1. Create CA ----
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/CN=My Test CA" -out ca.crt

# ---- 2. Server cert for web1 ----
openssl genrsa -out server1.key 2048
openssl req -new -key server1.key -subj "/CN=web1" -out server1.csr
cat > server1.ext <<EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = web1
DNS.2 = localhost
EOF
openssl x509 -req -in server1.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server1.crt -days 825 -sha256 -extfile server1.ext

# ---- 3. Server cert for web2 ----
openssl genrsa -out server2.key 2048
openssl req -new -key server2.key -subj "/CN=web2" -out server2.csr
cat > server2.ext <<EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = web2
DNS.2 = localhost
EOF
openssl x509 -req -in server2.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server2.crt -days 825 -sha256 -extfile server2.ext

# ---- 4. Client cert (for testing with curl) ----
openssl genrsa -out client.key 2048
openssl req -new -key client.key -subj "/CN=mtls-client" -out client.csr
cat > client.ext <<EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out client.crt -days 825 -sha256 -extfile client.ext

# ---- 5. Wildcard server cert for reverse proxy (public-facing) ----
openssl genrsa -out proxy.key 2048
openssl req -new -key proxy.key -subj "/CN=*.example.net" -out proxy.csr
cat > proxy.ext <<EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.example.net
DNS.2 = example.net
EOF
openssl x509 -req -in proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out proxy.crt -days 825 -sha256 -extfile proxy.ext


echo "Certificates generated in $(pwd)"
