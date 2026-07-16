from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
import os

# In production, this path will point to where the root repo is cloned
DBT_PROJECT_DIR = os.getenv("DBT_PROJECT_DIR", "/usr/local/airflow/dbt_transformation/olist_analytics")

default_args = {
    'owner': 'data_engineering_team',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'olist_medallion_pipeline',
    default_args=default_args,
    description='Runs the dbt Medallion pipeline for O-List',
    schedule_interval='@daily',
    start_date=datetime(2023, 1, 1),
    catchup=False,
) as dag:

    # 1. Test the connection and source data
    dbt_debug = BashOperator(
        task_id='dbt_debug',
        bash_command=f'dbt debug --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROJECT_DIR}',
    )

    # 2. Run the full Medallion pipeline
    dbt_build = BashOperator(
        task_id='dbt_build',
        bash_command=f'dbt build --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROJECT_DIR}',
    )

    dbt_debug >> dbt_build