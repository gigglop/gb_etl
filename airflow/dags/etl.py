from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook


# from dotenv import dotenv_values, find_dotenv
# config = dotenv_values(find_dotenv('.env'))
# config.get('AIRFLOW_SOURCE_CONNECTION_NAME')
# config.get('AIRFLOW_TARGET_CONNECTION_NAME')


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2022, 10, 10),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": False,
}


def select(conn_id, table):
    postgres_hook = PostgresHook(conn_name_attr=conn_id)
    postgres_hook.bulk_dump(table, f'tmp_{table}')


def insert(conn_id, table):
    postgres_hook = PostgresHook(conn_name_attr=conn_id)
    postgres_hook.bulk_load(table, f'tmp_{table}')


with DAG(
    dag_id="test_customer",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    tags=['data-flow'],
) as dag:
    select_from_table = PythonOperator(
        task_id='select_from_table',
        python_callable=select,
        op_kwargs={
            'conn_id': 'source_conn',
            'table': 'customer'
        }
    )

    insert_into_table = PythonOperator(
        task_id='insert_into_table',
        python_callable=insert,
        op_kwargs={
            'conn_id': 'target_conn',
            'table': 'customer'
        }
    )

    select_from_table >> insert_into_table
