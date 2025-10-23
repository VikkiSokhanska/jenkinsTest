#!/usr/bin/env bashls
set -e

# --- Ensure logs path exists even when the project dir is bind-mounted
mkdir -p /app/logs
: > /app/logs/django.log

# Wait for PostgreSQL
: "${DB_HOST:=db}"
: "${DB_PORT:=5432}"
echo "Waiting for Postgres at ${DB_HOST}:${DB_PORT}..."
until nc -z "${DB_HOST}" "${DB_PORT}"; do
  sleep 1
done
echo "Postgres is up."

# IMPORTANT: with a seeded DB, use --fake-initial to align migration history
python manage.py migrate --fake-initial --noinput

# Optional superuser auto-create (only if you set these env vars)
if [ -n "${DJANGO_SUPERUSER_EMAIL}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD}" ]; then
  echo "Creating superuser ${DJANGO_SUPERUSER_EMAIL} (if not exists)..."
  python manage.py createsuperuser --noinput || true
fi

# Static files (safe no-op in dev)
python manage.py collectstatic --noinput || true

echo "Starting app: $*"
exec "$@"