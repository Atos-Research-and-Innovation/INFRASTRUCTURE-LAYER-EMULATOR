#!/bin/<distr_shell>

# Database connection details
DB_NAME="ile"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="172.19.128.189"
DB_PORT="5432"
TABLE_NAME=$(echo $(hostname) | sed 's/-/_/g')

# Export the password to avoid being prompted
export PGPASSWORD="$DB_PASSWORD"

# SQL command to create the table
SQL_COMMAND=$(cat <<EOF
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP,
    status BOOLEAN
);
EOF
)

# Run the SQL command using psql
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$SQL_COMMAND"

# Check if the table creation was successful
if [ $? -eq 0 ]; then
    echo "Table created successfully."
else
    echo "Error creating table."
fi

# Unset the password variable for security reasons
unset PGPASSWORD