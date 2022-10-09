from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.postgres_operator import PostgresOperator


from dotenv import dotenv_values, find_dotenv
config = dotenv_values(find_dotenv('.env'))
# config.get('AIRFLOW_SOURCE_CONNECTION_NAME')
# config.get('AIRFLOW_TARGET_CONNECTION_NAME')


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2021, 6, 3),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": False,
}

with DAG(
    dag_id="test_customer",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    tags=['data-flow'],
) as dag:
    insert_my_data = PostgresOperator(
    task_id='insert_my_data',
    postgres_conn_id='postgres_target',
    sql="INSERT INTO customer VALUES ( -999, 'name', 'address', 0, 'phone', 0, 'mktsegment', 'comment')"
    )
