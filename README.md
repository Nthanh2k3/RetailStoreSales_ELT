# ELT Data Pipeline — CSV → MySQL (raw) → Postgres RDS (silver/golden) → Power BI

This project builds an ELT pipeline that ingests **CSV** files into a local **MySQL (raw)** database, orchestrates jobs with **Airflow**, transforms data into **Postgres RDS** using **dbt**, and visualizes results in **Power BI**.

![workflow](workflow.PNG)

---

## Tech stack (pinned)

- **Airflow**: `3.0.4`
- **dbt**: `1.10.9` (adapter: `dbt-postgres`)
- **MySQL**: `8.0`
- **PostgreSQL (AWS RDS)**: target warehouse for `silver` & `golden` schemas
- **Docker / Docker Compose`**

---

## Quickstart (TL;DR)

> Follow these steps in order.

**Step 1 — Pull images**

```bash
docker pull mysql:8.0
docker pull apache/airflow:3.0.4
# If you use a dedicated dbt image:
docker pull ghcr.io/dbt-labs/dbt-postgres:1.10.9
```

**Step 2 — Start the stack**

```bash
docker-compose up -d
```

**Step 3 — Open Airflow**

- URL: **http://localhost:8080**
- Login: **airflow**
- Password: **airflow**

**Step 4 — Ensure AWS RDS is running**

- Start your **PostgreSQL RDS** instance and allow inbound `5432` from your IP.

**Step 5 — Trigger DAG #1: `MySQL to RDS Migration`**

- Loads CSV → **MySQL (raw)** and migrates to **Postgres RDS** (e.g., `raw` or `silver_staging`).

**Step 6 — Trigger DAG #2: `dbt_process_data`**

- Runs **dbt** to transform into **silver** and **golden** schemas (optionally `dbt test`).

---

## Prerequisites

- Docker & Docker Compose installed
- CSV files placed in a mounted folder (e.g., `./data/csv/`)
- AWS RDS PostgreSQL instance (running), security group open on `5432`
- Credentials for:
  - **MySQL (local container)**: RAW landing
  - **Postgres RDS**: SILVER & GOLDEN targets
- Power BI Desktop (optional – for visualization)

---

## Project Structure (suggested)

```
.
├─ airflow/                 # dags/, plugins/, requirements.txt (optional)
│  ├─ dags/
│  │  ├─ mysql_to_rds_migration.py      # DAG #1
│  │  └─ dbt_process_data.py            # DAG #2
│
├─ dbt/
│  ├─ profiles.yml          # points to Postgres RDS
│  └─ <retail_dbt>/   # models: staging/silver/golden
├─ data/
│  └─ csv/                  # place your input CSV files here
├─ docker-compose.yml
├─ workflow.PNG             # architecture diagram
└─ README.md
```

---

## Environment Variables

Create a `.env` file at the repo root (or `airflow/.env` depending on your compose mounts).

```env
# MySQL (raw)
MYSQL_HOST=mysql
MYSQL_PORT=3306
MYSQL_DATABASE=raw
MYSQL_USER=raw_user
MYSQL_PASSWORD=raw_password

# Postgres RDS (silver/golden)
PG_HOST=db-thanhnv164-postgres.ceahrljdchqz.us-east-1.rds.amazonaws.com
PG_PORT=5432
PG_DATABASE=postgres
PG_USER=postgres
PG_PASSWORD=Ngthanh23_12
PG_SSLMODE=require

# Airflow
AIRFLOW__WEBSERVER__RBAC=True
AIRFLOW_UID=50000
```

> Ensure your `dbt/profiles.yml` uses the same Postgres RDS settings.

---

## Airflow Setup

### Connections (UI → **Admin → Connections**)

- **`mysql_raw`** (Conn Type: MySQL)  
  Host: `mysql`, Port: `3306`, Schema: `raw`, Login/Password from `.env`.

- **`postgres_rds`** (Conn Type: Postgres)  
  Host: `<your RDS endpoint>`, Port: `5432`, Schema: DB name, Login/Password from `.env`, **Extra**: `{"sslmode":"require"}` (optional).

### Variables (UI → **Admin → Variables**) — optional

- `RAW_SCHEMA = raw`
- `SILVER_SCHEMA = silver`
- `GOLDEN_SCHEMA = golden`
- Any CSV path the DAGs expect (e.g., `/opt/airflow/data/csv`).

---

## Running the Pipeline (detailed)

1. **Ingest CSV to MySQL + migrate to RDS**  
   Trigger **`MySQL to RDS Migration`**.  
   Typical steps inside the DAG:
   - Create or verify RAW tables in MySQL
   - Load CSVs into **MySQL (raw)**
   - Migrate data to **Postgres RDS** (`raw` or `silver_staging`)

2. **Transform with dbt**  
   Trigger **`dbt_process_data`**.  
   Common tasks:
   - `dbt deps`
   - `dbt run --select path:models/silver`
   - `dbt run --select path:models/golden`
   - Optional: `dbt test`

---

## Connect Power BI

- Connect Power BI to **Postgres RDS** (read-only user recommended)
- Use the **`golden`** schema for reporting (facts: `fct_*`, dims: `dim_*_scd`)

---

## Useful Commands

```bash
# See running services
docker ps

# Follow Airflow logs
docker-compose logs -f airflow-webserver
docker-compose logs -f airflow-scheduler

# Exec into containers
docker exec -it airflow-webserver bash
docker exec -it mysql mysql -uroot -p

# Stop the stack
docker-compose down

# Clean volumes (CAUTION: deletes data)
docker-compose down -v
```

---

## Troubleshooting

- **DAGs not visible** → verify `airflow/dags/` volume and file names end with `.py`.
- **Cannot reach RDS** → check AWS SG inbound `5432`, VPC routing, and/or SSL mode.
- **dbt errors** → run inside the dbt container:
  ```bash
  dbt --version      # should be 1.10.9
  dbt debug
  dbt run --select path:models/silver
  dbt run --select path:models/golden
  ```
- **CSV not loaded** → ensure data path is mounted and matches DAG configuration.

---

## Security Notes

- Use a **read-only** Postgres user for BI tools.
- Keep secrets out of Git; use env vars or a secret manager.
- Restrict RDS access to office/VPN IPs; enable SSL (`sslmode=require`).

---

## Versions & Compatibility

- Airflow **3.0.4**
- dbt **1.10.9** (`dbt-postgres`)
- MySQL **8.0**
- Postgres **≥ 13** recommended

Pin exact image tags in `docker-compose.yml` to avoid unexpected upgrades.

---

**Happy ELT-ing!**
