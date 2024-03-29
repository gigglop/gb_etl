from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook
import os


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2022, 10, 10),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": False,
}


TABLE_LIST = [
    'customer',
    'lineitem',
    'nation',
    'orders',
    'part',
    'partsupp',
    'region',
    'supplier'
]


def select(**kwargs):
    postgres_hook = PostgresHook(postgres_conn_id=kwargs['conn_id'])
    postgres_hook.bulk_dump(kwargs['table'], f"tmp_{kwargs['table']}")


def insert(**kwargs):
    postgres_hook = PostgresHook(postgres_conn_id=kwargs['conn_id'])
    postgres_hook.bulk_load(kwargs['table'], f"tmp_{kwargs['table']}")
    os.remove(f"tmp_{kwargs['table']}")


dag = DAG(
    dag_id="etl",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    tags=['data-flow'],
    catchup=False
)
for table in TABLE_LIST:

    select_from_table = PythonOperator(
        task_id=f'select_from_source_{table}',
        python_callable=select,
        op_kwargs={
            'conn_id': os.environ['AIRFLOW_SOURCE_CONNECTION_NAME'],
            'table': table
        },
        dag=dag
    )

    insert_into_table = PythonOperator(
        task_id=f'insert_into_target_{table}',
        python_callable=insert,
        op_kwargs={
            'conn_id': os.environ['AIRFLOW_TARGET_CONNECTION_NAME'],
            'table': table
        },
        dag=dag
    )

    select_from_table >> insert_into_table
