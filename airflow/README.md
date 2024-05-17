Cloned from https://github.com/DataDog/integrations-core/tree/master/airflow/tests/k8s_sample
This uses an outdated airflow helm chart

Issues:
 1. Issue running the py scripts
 ```
 /opt/homebrew/lib/python3.10/site-packages/airflow/models/base.py:49 MovedIn20Warning: [31mDeprecated API features detected! These feature(s) are not compatible with SQLAlchemy 2.0. [32mTo prevent incompatible upgrades prior to updating applications, ensure requirements files are pinned to "sqlalchemy<2.0". [36mSet environment variable SQLALCHEMY_WARN_20=1 to show all deprecation warnings.  Set environment variable SQLALCHEMY_SILENCE_UBER_WARNING=1 to silence this message.[0m (Background on SQLAlchemy 2.0 at: https://sqlalche.me/e/b8d9)
/Users/steve.zou/Desktop/Minikube/airflow/dags/task_ok.py:8 DeprecationWarning: The `airflow.operators.dummy_operator.DummyOperator` class is deprecated. Please use `'airflow.operators.empty.EmptyOperator'`.
/Users/steve.zou/Desktop/Minikube/airflow/dags/task_ok.py:9 DeprecationWarning: The `airflow.operators.python_operator.PythonOperator` class is deprecated. Please use `'airflow.operators.python.PythonOperator'`.
/Users/steve.zou/Desktop/Minikube/airflow/dags/task_ok.py:16 RemovedInAirflow3Warning: Param `schedule_interval` is deprecated and will be removed in a future release. Please use `schedule` instead.
```
 https://github.com/apache/airflow/issues/28723
