Tailing JSON file.
1. create json log file on local machine.
2. copy file over to minikube using:
sudo minikube cp /path/to/json/file minikube:/path/to/destination
3. configure annotations to tail file:
ad.datadoghq.com/CONTAINER_IDENTIFIER.logs: '[{"source":"...","service":"...","type":"file","path":"/path/to/file"}]'
