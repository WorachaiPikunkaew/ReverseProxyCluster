# Get current IPs of web1/web2 on mtls-net
WEB1_IP=$(docker inspect -f '{{(index .NetworkSettings.Networks "demo-net").IPAddress}}' web1)
WEB2_IP=$(docker inspect -f '{{(index .NetworkSettings.Networks "demo-net").IPAddress}}' web2)
echo "web1=$WEB1_IP  web2=$WEB2_IP"
cat > 03-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-proxy
  namespace: mtls-proxy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-proxy
  template:
    metadata:
      labels:
        app: nginx-proxy
    spec:
      # Map web1/web2 hostnames to their Docker-network IPs
      hostAliases:
        - ip: "$WEB1_IP"     # <-- replace with $WEB1_IP
          hostnames: ["web1"]
        - ip: "$WEB2_IP"     # <-- replace with $WEB2_IP
          hostnames: ["web2"]
      containers:
        - name: nginx
          image: nginx:stable
          ports:
            - containerPort: 80
            - containerPort: 443
          volumeMounts:
            - name: nginx-conf
              mountPath: /etc/nginx/conf.d/default.conf
              subPath: default.conf
            - name: certs
              mountPath: /etc/nginx/certs
              readOnly: true
          readinessProbe:
            tcpSocket:
              port: 443
            initialDelaySeconds: 3
            periodSeconds: 5
      volumes:
        - name: nginx-conf
          configMap:
            name: proxy-nginx-conf
        - name: certs
          secret:
            secretName: proxy-certs
EOF
