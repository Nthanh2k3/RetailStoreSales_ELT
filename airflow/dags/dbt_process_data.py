from __future__ import annotations

from datetime import datetime
import json
import os

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.http.hooks.http import HttpHook
from airflow.sdk import Variable


TEAMS_CONN_ID = "ms_teams_webhook"          
TEAMS_ENDPOINT_VAR = "TEAMS_WEBHOOK_ENDPOINT"  

def teams_notify(context, status: str) -> None:
    endpoint = Variable.get(TEAMS_ENDPOINT_VAR)
    ti = context["ti"]
    dag_id = context["dag"].dag_id
    task_id = ti.task_id
    run_id = context["run_id"]
    log_url = ti.log_url

    message = (
        f"**[{status}]** DAG `{dag_id}` → task `{task_id}`\n"
        f"Run: `{run_id}`\n"
        f"[Xem log]({log_url})"
    )
    if "test" in task_id and status == "FAILED":
        message += "\n**Errors**: Checking data quality failed, please checked again."
    payload = {"text": message}
    http = HttpHook(method="POST", http_conn_id=TEAMS_CONN_ID)
    http.run(
        endpoint=endpoint,
        data=json.dumps(payload),
        headers={"Content-Type": "application/json"},
    )

with DAG(
    dag_id="dbt_pipeline_invalid_staging_silver",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",         
    catchup=False,
    default_args={
        "on_failure_callback": lambda ctx: teams_notify(ctx, "FAILED"),
        "on_success_callback": lambda ctx: teams_notify(ctx, "SUCCESS"),
    },
    tags=["dbt", "teams"],
) as dag:

    DBT_PROJECT_DIR = os.environ.get("DBT_PROJECT_DIR", "/opt/airflow/dbt")
    DBT_PROFILES_DIR = os.environ.get("DBT_PROFILES_DIR", "/home/airflow/.dbt")

    dbt_invalid = BashOperator(
        task_id="dbt_invalid",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt run --select path:models/invalid --full-refresh "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_staging = BashOperator(
        task_id="dbt_staging",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt run --select path:models/staging --full-refresh "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_silver = BashOperator(
        task_id="dbt_silver",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt run --select path:models/silver --full-refresh "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_test_silver = BashOperator(
        task_id="dbt_test_silver",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt test --select path:models/silver "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot_run",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt snapshot --profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_golden = BashOperator(
        task_id="dbt_golden",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt run --select path:models/golden --full-refresh "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_test_golden = BashOperator(
        task_id="dbt_test_golden",
        bash_command=(
            "cd {{ params.project_dir }} && "
            "dbt test --select path:models/golden "
            "--profiles-dir {{ params.profiles_dir }}"
        ),
        params={"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR},
    )

    dbt_staging >> dbt_invalid >> dbt_silver >> dbt_test_silver >> dbt_snapshot >> dbt_golden >> dbt_test_golden