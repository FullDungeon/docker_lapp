#!/bin/bash
set -e

function create_database() {
    local db_name=$1

    echo "Creating database '$db_name'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE $db_name;
        GRANT ALL PRIVILEGES ON DATABASE $db_name TO $POSTGRES_USER;
EOSQL
}

if [ -n "$POSTGRES_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_DATABASES"

    for db_name in $(echo $POSTGRES_DATABASES | tr ':' ' '); do
        create_database $db_name
    done

    echo "Multiple databases created"
fi