## Minikube

#### Prerequisites:
- [Docker Installed](https://docs.docker.com/desktop/install/mac-install/)
- [minikube installed](https://datadoghq.atlassian.net/wiki/spaces/TS/pages/1248530082/How+to+test+Kubernetes+yourself)

#### Objective
Understand how to spin up your own Kubernetes Sandbox and configure the Datadog agent to collect metrics/logs.

#### Spinning up Minikube
You can start up minikub using the following command:
``minikube start``
This will spin up a single node cluster on your machine

#### Useful Commands
```
kubectl get <RESOURCE>
kubectl apply -f PATH/TO/FILE
kubectl describe <RESOURCE> <NAME>
kubectl exec -it <POD_NAME> -- <COMMAND>
helm install <RELEASE_NAME> -f PATH/TO/FILE datadog/datadog
helm upgrade <RELEASE_NAME> -f PATH/TO/FILE datadog/datadog
```
#### Deploying the Agents
We will be deploying the datadog agents using the helm chart. 
In the ``values.yaml`` file, add your API key here:
```
apiKey: <DATADOG_API_KEY>
```
You could also create a Kubernetes secret to store the API key
Encode your API key using:
```echo -n 'API_KEY' | openssl base64```
Paste the output in ``secret.yaml`` and create this secret using:
```kubectl apply -f secret.yaml```
This creates a secret named ``datadog-agent`` which you can then use in your values.yaml file:
```
apiKeyExistingSecret: datadog-agent
```

Deploy the helm chart:
```
helm install datadog -f values.yaml datadog/datadog
```

#### Deploying Redis
```
kubectl apply -f redis.yaml
```

#### Deploying Logger
```
kubectl apply -f logger.yaml
```
This pod emits logs into a file(as opposed to STDOUT/STDERR) so we'll have to tell the agent to look for the logs in the file path using annotations:
```
ad.datadoghq.com/busybox.logs: '[{"source": "busybox","service": "my-app","type": "file","path": "/var/log/example/app*.log"}]'
```

We can confirm that the pod is indeed emitting logs to a file using:
```
kubectl exec -it <POD_NAME> ls /var/log/example
kubectl exec -it <POD_NAME> cat /var/log/example/app.log
```

#### Deploying Openmetrics
We will be setting up a server that imitates a prometheus deployment. We can do this by spinning a pod running a python server that is exposing metrics on port 8000. This data emitted by this server is defined in the ConfigMap located in ``openmetrics/data.yaml``

##### Deploying the configmap
```
kubectl apply -f openmetrics/metrics.yaml
```
Confirm that the configmap was created successfully and contains the data:
```
kubectl describe configmap openmetrics-data
```

##### Deploying the server
```
kubectl apply -f openmetrics/deployment.yaml
```
You should now see a pod named ``prometheus-deployment...`` deployed. We can get the IP of the pod using:
```
kubectl get pod -o wide
```
Using the prometheus-deployment pod IP, we can curl the metrics endpoint exposed by the server:
```
kubectl exec -it <AGENT_POD_NAME> -- curl <POD_IP>:8000/metrics
```

#### Cleanup
```
kubectl delete pod redis
kubectl delete deployment random-logger
kubectl delete deployment prometheus-deployment
helm uninstall datadog
minikube stop
```
