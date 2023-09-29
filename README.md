# helm-sops-values

## Docker images build
```
docker build -f argocd/Dockerfile -t example/argocd:v2.8.4 .
```

## Install 
```
1) Download argocd helm chart
wget https://github.com/argoproj/argo-helm/releases/download/argo-cd-3.35.4/argo-cd-3.35.4.tgz

2) Values example
cat > values.yaml << EOF
---
global:
  image:
    repository: example/argocd
    tag: "v2.8.4"

server:
  extraArgs:
    - --insecure

repoServer:
  volumes:
    - name: helm-secrets-private-keys
      secret:
        secretName: helm-secrets-private-keys
  volumeMounts:
    - mountPath: /helm-secrets-private-keys/
      name: helm-secrets-private-keys

redis:
  enabled: true

redis-ha:
  enabled: false
EOF

3) Install argocd
helm template argocd argo-cd-3.35.4.tgz --namespace=argocd --values=values.yaml | kubectl apply --namespace=argocd --filename=-

4) Download and install SOPS and AGE on your local machine
The installation can be viewed in the Dockerfile

5) Generate key and encrypt using SOPS
age-keygen -o key.asc
sops -e helm-chart/values.yaml > helm-chart/values.enc.yaml

6) Сreate secret AGE
kubectl create secret generic helm-secrets-private-keys --from-file=key.asc -n argocd

7) Apply in Apply manifests for a project in Argocd
kubectl apply -f argocd/argo-cd-app/

8) Check admin pass
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo

9) Forward the port to enter the web application
kubectl port-forward service/argocd-server 8080:80 -n argocd

10) Check web argocd
http://localhost:8080
```
