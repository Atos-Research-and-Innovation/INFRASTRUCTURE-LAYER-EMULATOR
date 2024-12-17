#!/bin/<distr_shell>

# Verify total arguments number.
if [ $# -ne 1 ]; then
    echo "Usage: $0 [conversion factor (1/60/3600)] [initial state (0/1)] [timestamp1] [timestamp2] [...]"
    exit 1
fi

conversion_factor=$1
times=$2
time_start=$3

# CONNECTO TO DATABASE
# ---------------------------
# Database connection details
DB_NAME="ile"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="172.19.128.189"
DB_PORT="5432"
TABLE_NAME=$(echo $(hostname) | sed 's/-/_/g')

# Export the password to avoid being prompted
export PGPASSWORD="$DB_PASSWORD"
# ---------------------------

# Convert the time when the emulation must start to seconds.
time_start_ttmp=$(date -d "$time_start" +"%s")
# Convert the current time to seconds.
curr_date_ttmp=$(date +"%s")

# Calculate the difference between both.
time_diff=$((time_start_ttmp - curr_date_ttmp))

# Wait until the the current time is equal to the emulation start time.
sleep $time_diff

while true; do

    # Access the config file to get the status.
    curr_status=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')

    if [ "$curr_status" == "running" ]; then
        # Add a True value if the container is running.
        psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "INSERT INTO $TABLE_NAME (timestamp, status) VALUES (CURRENT_TIMESTAMP, TRUE);"
    else
        # Add a False value if the container is stand by.
        psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "INSERT INTO $TABLE_NAME (timestamp, status) VALUES (CURRENT_TIMESTAMP, FALSE);"
    fi

    # Sleep the number of seconds that we want to wait until the container inserts a new timeseries value.
    sleep 2

done