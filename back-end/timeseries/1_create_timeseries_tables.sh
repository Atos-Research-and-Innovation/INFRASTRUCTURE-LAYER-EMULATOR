#!/bin/bash

# Database connection details
#----------------------------
DB_NAME="ile"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="localhost"
DB_PORT="5432"
TABLE_NAME_TIMESERIES=ILE_TIMESERIES
TABE_NAME_CONTAINERS=ILE_CONTAINERS
#----------------------------

# Export the password to avoid being prompted
export PGPASSWORD="$DB_PASSWORD"

# SQL command to create the timeseries table
SQL_TIMESERIES_COMMAND=$(cat <<EOF
CREATE TABLE IF NOT EXISTS $TABLE_NAME_TIMESERIES (
    id SERIAL PRIMARY KEY,
    container_id INTEGER,
    timestamp TIMESTAMP,
    status BOOLEAN
);
EOF
)

# SQL command to create the containers table
SQL_CONTAINERS_COMMAND=$(cat <<EOF
CREATE TABLE IF NOT EXISTS $TABE_NAME_CONTAINERS (
    id SERIAL PRIMARY KEY,
    container_name TEXT
);
EOF
)

# Run the SQL commands using psql
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$SQL_TIMESERIES_COMMAND"

# Check if the table creation was successful
if [ $? -eq 0 ]; then
    echo "Table $TABLE_NAME_TIMESERIES created successfully."
else
    echo "Error creating table $TABLE_NAME_TIMESERIES."
fi

psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$SQL_CONTAINERS_COMMAND"

# Check if the table creation was successful
if [ $? -eq 0 ]; then
    echo "Table $TABE_NAME_CONTAINERS created successfully."
else
    echo "Error creating table $TABE_NAME_CONTAINERS."
fi

# Unset the password variable for security reasons
unset PGPASSWORD