# Dogstatsd Sandbox

### Prerequsites
1. [Python installed](https://www.python.org/downloads/)
2. pip installed
    ```
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    ```
3. Minikube + Helm
    [KB on setting up Minikube](https://datadoghq.atlassian.net/wiki/spaces/TS/pages/1248530082/How+to+test+Kubernetes+yourself)
4. Docker account created
    [Signup](https://hub.docker.com/signup)

###Creating python image and deploying to Dockerhub
Build image using Dockerfile:
``docker build -t python-dsd .``

Confirm that the image has been created:
```
docker image ls
REPOSITORY                    TAG       IMAGE ID       CREATED         SIZE
python-dsd                    latest    86313b995952   8 seconds ago   209MB
```

Log into Docker in your terminal:
``docker login --username <USERNAME>``

Tag the image:
``docker image tag <IMAGE_NAME> <DOCKER_USERNAME>/<IMAGE_NAME>:<TAG>``
Push image onto your Docker Hub:
``docker image push <DOCKER_USERNAME>/<IMAGE_NAME>:<TAG>``

Deploying the Application
``kubectl apply -f deployment.yaml``



### Troubleshooting
Enable dogstatsd stats:
``kubectl exec -it AGENT_POD agent config set dogstatsd_stats true``
Get dogstatds stats:
``kubectl exec -it AGENT_POD agent dogstatsd-stats``
