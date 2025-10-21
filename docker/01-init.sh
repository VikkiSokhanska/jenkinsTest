#!/usr/bin/env sh
#set -euo pipefail
set -e
# Substitute env vars in the SQL template and run it
#envsubst < /docker-entrypoint-initdb.d/01-init.sql.tmpl > /tmp/01-init.sql
#psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /tmp/01-init.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE ROLE "${PG_USER}" LOGIN PASSWORD '${PG_PASSWORD}';
  ALTER DATABASE "${POSTGRES_DB}" OWNER TO "${PG_USER}";
  ALTER SCHEMA public OWNER TO "${PG_USER}";
  GRANT USAGE, CREATE ON SCHEMA public TO "${PG_USER}";
EOSQL