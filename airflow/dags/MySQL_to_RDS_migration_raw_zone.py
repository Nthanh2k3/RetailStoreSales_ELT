from __future__ import annotations

from datetime import datetime, timedelta
from typing import List

import pandas as pd
from sqlalchemy import create_engine, Text, text  

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.mysql.hooks.mysql import MySqlHook
from airflow.providers.postgres.hooks.postgres import PostgresHook

# ---- CONFIG ----
MYSQL_CONN_ID = "mysql_default"      # Airflow Conn: mysql://admin:nectar23_12@mysql:3306/retail_db
MYSQL_DB      = "retail_store_db"
PG_CONN_ID    = "pg_raw"           # Airflow Conn: postgresql+psycopg2://.../raw?sslmode=require
PG_SCHEMA     = "raw"              # target schema in Postgres (database name is in the conn)
BATCH_SIZE    = 10_000

TABLES: List[str] = [
    "brands","campaigns","categories","customer_feedback","customers","discount_rules",
    "employees","inventory","loyalty_programs","payments","pricing_history","products",
    "promotions","purchase_orders","returns","sales_items","sales_transactions","shipments",
    "stock_movements","store_visits","stores","suppliers","tax_rules"
]

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime.now() - timedelta(days=1),
    "retries": 0,
}

dag = DAG(
    "Rawzone_Migration",
    default_args=default_args,
    description="Load data from local MySQL to AWS RDS Postgres (raw schema) via SQLAlchemy",
    schedule=None,
    catchup=False,
    tags=["mysql","postgres","sqlalchemy","raw"],
)

# ---------- helpers ----------
def q_mysql_ident(s: str) -> str:
    return "`" + s.replace("`", "``") + "`"

def q_pg_ident(s: str) -> str:
    return '"' + s.replace('"', '""') + '"'

# ---------- tasks ----------
def create_schema() -> None:
    """Create the target Postgres schema if it doesn't exist."""
    pg = PostgresHook(postgres_conn_id=PG_CONN_ID)
    engine = pg.get_sqlalchemy_engine()  # correct engine for Postgres
    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {q_pg_ident(PG_SCHEMA)};"))

create_schema_task = PythonOperator(
    task_id="create_raw_schema",
    python_callable=create_schema,
    dag=dag,
)

def migrate_table(table_name: str) -> None:
    """
    1) Read column list from MySQL (with explicit schema)
    2) Ensure target table exists in Postgres (all TEXT) in same column order
    3) SELECT from MySQL with explicit column list and load via pandas.to_sql(schema='raw')
    """
    # 1) columns from MySQL
    mysql = MySqlHook(mysql_conn_id=MYSQL_CONN_ID)
    cols_rows = mysql.get_records(
        f"SHOW COLUMNS FROM {q_mysql_ident(MYSQL_DB)}.{q_mysql_ident(table_name)}"
    )
    col_names = [row[0] for row in cols_rows]
    if not col_names:
        print(f"[WARN] No columns found for {table_name}; skipping.")
        return

    # 2) ensure Postgres table (TEXT columns, same order)
    pg = PostgresHook(postgres_conn_id=PG_CONN_ID)
    pg_engine = pg.get_sqlalchemy_engine()

    col_defs = ", ".join(f'{q_pg_ident(c)} TEXT' for c in col_names)
    create_sql = text(
        f"CREATE TABLE IF NOT EXISTS {q_pg_ident(PG_SCHEMA)}.{q_pg_ident(table_name)} ({col_defs});"
    )
    truncate_sql = text(
        f"TRUNCATE TABLE {q_pg_ident(PG_SCHEMA)}.{q_pg_ident(table_name)};"
    )

    with pg_engine.begin() as conn:
        conn.execute(create_sql)
        # full refresh; comment out if you want incremental later
        conn.execute(truncate_sql)

    # 3) fetch from MySQL and write to Postgres
    select_list = ", ".join(q_mysql_ident(c) for c in col_names)
    sql = f"SELECT {select_list} FROM {q_mysql_ident(MYSQL_DB)}.{q_mysql_ident(table_name)}"
    df = mysql.get_pandas_df(sql=sql)

    # normalize: convert NaN->'' so they become NULL if you want; or keep NaN and let to_sql handle
    df = df.astype(object).where(pd.notnull(df), "")

    dtype_map = {c: Text() for c in col_names}  # all TEXT

    # Use schema argument instead of embedding 'raw.' in table name
    with pg_engine.begin() as conn:
        df.to_sql(
            name=table_name,
            schema=PG_SCHEMA,
            con=conn,
            if_exists="append",
            index=False,
            dtype=dtype_map,
            method="multi",
            chunksize=BATCH_SIZE,
        )
    print(f"[OK] Migrated {table_name} ({len(df)} rows).")

# one PythonOperator per table
for t in TABLES:
    PythonOperator(
        task_id=f"migrate_{t}",
        python_callable=migrate_table,
        op_kwargs={"table_name": t},
        dag=dag,
    )
    create_schema_task >> dag.task_dict[f"migrate_{t}"]
