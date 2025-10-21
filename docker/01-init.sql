CREATE ROLE forumuser LOGIN PASSWORD 'forumpass';
\connect forum
ALTER SCHEMA public OWNER TO forumuser;
GRANT USAGE, CREATE ON SCHEMA public TO forumuser;