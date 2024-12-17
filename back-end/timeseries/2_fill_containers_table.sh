#!/bin/bash

# Database connection details
#----------------------------
DB_NAME="ile"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="localhost"
DB_PORT="5432"
TABE_NAME_CONTAINERS="ILE_CONTAINERS"
#----------------------------

# Export the password to avoid being prompted
export PGPASSWORD="$DB_PASSWORD"

cnt_names=$(lxc list -c n --format csv)

for cnt_name in $cnt_names; do
    cnt_domain=$(lxc exec $cnt_name -- sh -c "cat \"/usr/share/ils/conf/container_info.csv\" | grep \"^Domain,\" | cut -d ',' -f 2 | sed 's/^[[:space:]]*//'")
    if [ $cnt_domain = "eedg" ]; then
        psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "INSERT INTO $TABE_NAME_CONTAINERS (container_name) VALUES ('$cnt_name');"
    fi
done

# Unset the password variable for security reasons
unset PGPASSWORD