#!/usr/bin/env sh
set -e

# Rewrite any OWNER clauses to forumuser so the import runs without superuser
# and the objects end up owned by the app role.
sed -E 's/OWNER TO [^;]+;/OWNER TO forumuser;/g' /seed/forum_d.sql \
| psql -v ON_ERROR_STOP=1 -U forumuser -d forum
