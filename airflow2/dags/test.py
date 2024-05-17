import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator

my_dag = DAG(
     dag_id="my_dag_name",
     start_date=datetime.datetime(2023, 3, 20),
     schedule="@daily",
)
EmptyOperator(task_id="task", dag=my_dag)