# syntax=docker/dockerfile:1
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps (psycopg2, waiting for DB, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev netcat-traditional curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir gunicorn

# Copy the project
COPY . .

# Ensure log directory exists (the project logs to ./logs/)
RUN mkdir -p logs && touch logs/django.log

# Non-root user
RUN useradd -u 10001 -ms /bin/bash appuser && chown -R appuser:appuser /app
USER appuser

# By default, we'll rely on manage.py (dev) or gunicorn (prod-ish) from entrypoint
COPY docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# --- DEV (default command) ---
# For development, use Django's runserver (auto-reload when volume-mounted)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]