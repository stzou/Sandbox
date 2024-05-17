
### Installing Argo CD
Create a new namespace named ``argocd`` where argocd resources will live:
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
### Installing the Argo CD CLI:
```
brew install argocd
```

### Accessing the Argo CD API server:
By default, the Argo CD API server is not exposed with an external IP. There are a few ways to expose the API server - for the sandbox, we will be port-fowarding:
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
The API server can be accessed using ``https://localhost:8080``

You can now log into the Argo CD server using a username and password.
The username will default to ``admin`` and the password can be retrieved using:
```
argocd admin initial-password -n argocd
```

You can either log in from the CLI or from the UI.
From the CLI:
```
argocd login localhost:8080 
```
From the UI:
Open https://localhost:8080

### Deploying From Github
Settings -> Repositories -> Connect Repo
Type:``git``
Project:``default``
Repository URL: ``https://github.com/DaniCalifornia/containers-pod-useast.git``

### Monitoring ArgoCD
Argo CD exposes Prometheus-formatted metrics on three of their components. We will need to add autodiscovery annotations for each one.
- Application Controller
```
annotations:
    ad.datadoghq.com/argocd-application-controller.checks: |
      {
        "argocd": {
          "init_config": {},
          "instances": [
            {
              "app_controller_endpoint": "http://%%host%%:8082/metrics"
            }
          ]
        }
      }      
```
- API Server
```
annotations:
    ad.datadoghq.com/argocd-server.checks: |
        {
        "argocd": {
            "init_config": {},
            "instances": [
            {
                "api_server_endpoint": "http://%%host%%:8083/metrics"
            }
            ]
        }
        }   
```
- Repo Server
```
annotations:
    ad.datadoghq.com/argocd-repo-server.checks: |
        {
        "argocd": {
            "init_config": {},
            "instances": [
            {
                "repo_server_endpoint": "http://%%host%%:8084/metrics"
            }
            ]
        }
        }
```
The deployment files for each of these components can be found here:
https://github.com/argoproj/argo-cd/blob/master/manifests/install.yaml
These annotations have been added to the respective yaml files. Apply the annotations using:
```
kubectl apply -f application-controller.yaml
kubectl apply -f argocd-repo-server.yaml
kubectl apply -f argocd-server.yaml
```


### Cleanup:
```
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete ns argocd
```

References:
https://argo-cd.readthedocs.io/en/stable/getting_started/?_gl=1*12a791x*_ga*MTMxOTIzNDA2MS4xNjgyNTI3NjYw*_ga_5Z1VTPDL73*MTY4MjUyNzY1OS4xLjAuMTY4MjUyNzY2Ny4wLjAuMA..

https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf
