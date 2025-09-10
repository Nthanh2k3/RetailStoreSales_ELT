# Dockerfile (thay thế nội dung hiện tại)
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/app

# Install dbt-core and dbt-postgres (stable versions)
RUN pip install --no-cache-dir \
    dbt-core==1.10.9 \
    dbt-postgres==1.9.0

# Create dbt directory
RUN mkdir -p /usr/app/dbt

# Set environment variables
ENV DBT_PROFILES_DIR=/root/.dbt

# Keep container running (files will be mounted via volumes)
CMD ["tail", "-f", "/dev/null"]