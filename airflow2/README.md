# Airflow
Airflow allows users to define a series of tasks that must be executed in a particular order to complete a workflow. These tasks can be anything from running a script or a program, to sending an email or a text message. Airflow makes it easy to manage dependencies between tasks, and provides a variety of tools for monitoring and troubleshooting workflows.

One of the main benefits of using Airflow is its ability to automate complex workflows. Airflow can schedule tasks to run at specific times, and can also trigger tasks based on events such as the completion of other tasks or the arrival of new data. This makes it an ideal platform for data processing, machine learning, and other types of automation.

Airflow is highly customizable and extensible, with a large number of plugins and integrations available. It also has a rich set of features, including a web-based user interface for managing workflows, a powerful task execution engine, and support for multiple execution

Following Quickstart Guide:
https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/guides/quickstart.md

## Executors
What are Executors?
https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/executor/index.html
Executors are the mechanism by which task instances get run. They have a common API and are “pluggable”, meaning you can swap executors based on your installation needs.

There are two types of executor - those that run tasks locally (inside the scheduler process), and those that run their tasks remotely (usually via a pool of workers)

This is being set with the ``airflow.executor`` param in our airflow_values.yaml:
```
airflow:
  executor: KubernetesExecutor
```

Using KubernetesExecutor as a starting point:
https://github.com/airflow-helm/charts/blob/main/charts/airflow/sample-values-KubernetesExecutor.yaml

## Airflow Configs
- Users
https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/security/airflow-users.md
- Connections
Airflow’s Connection object is used for storing credentials and other information necessary for connecting to external services. This can be defined under ``airflow.connections``
https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/dags/airflow-connections.md
- Variables
Variables are Airflow’s runtime configuration concept - a general key/value store that is global and can be queried from your tasks. This can be defined under ``airflow.variables``
https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/dags/airflow-variables.md
- Pools
Some systems can get overwhelmed when too many processes hit them at the same time. Airflow pools can be used to limit the execution parallelism on arbitrary sets of tasks. This can be defined under ``airflow.pools``
https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/dags/airflow-pools.md

## DAGs
### What are DAGs?
https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html#dags
A DAG (Directed Acyclic Graph) is the core concept of Airflow, collecting Tasks together, organized with dependencies and relationships to say how they should run.
The DAG itself doesn’t care about what is happening inside the tasks; it is merely concerned with how to execute them - the order to run them in, how many times to retry them, if they have timeouts, and so on.

DAGs are defined as python code and they need to be made available in the Airflow cluster through one of three ways:
1. Git-synch Sidecar
2. Persistent Volume Claim
3. Embedded Container Image

Ref: https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/dags/load-dag-definitions.md

We will be using the PVC method. In the helm file, the following

### Defing a DAG

### Loading a DAG

### Running a DAG
https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html#running-dags

## Databases

## Logs


## Datadog Airflow Integration Config:
```
  extraEnv:
    - name: DD_AGENT_HOST
      valueFrom:
        fieldRef:
          fieldPath: status.hostIP
    - name: AIRFLOW__SCHEDULER__STATSD_HOST
      valueFrom:
        fieldRef:
          fieldPath: status.hostIP
```