#!/bin/bash

# ./generate_timeseries_insert.sh 1 (Sampling Interval) 1 (Weeks) \
# "M(0,3:00,7:00,15:00,20:00)-T(0,2:00,12:00)-W(0,2:00,13:00)-R(0,2:00,12:00)-F(0,2:00,12:00)-S(0,2:00,12:00)-U(0,2:00,12:00)"

sampling_interval=$1
weeks=$2
cnt_name=$3
times=$4

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

# Get the current container ID
cnt_id=$(psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -t -A -c "SELECT id FROM $TABE_NAME_CONTAINERS WHERE container_name = '$cnt_name';")
echo "The container ID is: $cnt_id"

# Function to convert certain hour to seconds
hours_2_secs() {
  local hour=$1
  hours=$(echo "$hour" | awk -F':' '{print $1}')
  mins=$(echo "$hour" | awk -F':' '{print $2}')
  # Calcular la conversion a segundos desde las 00:00 horas hasta la hora proporcionada
  # Calculate the conversion to seconds from 00:00
  hour_seconds=$(( $hours * 3600 + $mins * 60 ))
  # THE VARIABLE HAS NO PRECISSION FOR TIME LESS THAN A SECOND. INVESTIGATE ON HOW TO DO THIS.
}

# Function to update the status value
update_status() {
    local curr_timestamp=$1
    local curr_status=$2
    curr_timestamp=$(date -d "@$curr_timestamp" +"%Y-%m-%d %H:%M:%S")
    psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "INSERT INTO $TABLE_NAME_TIMESERIES (timestamp, status, container_id) \
    VALUES ('$curr_timestamp', '$curr_status', '$cnt_id');"
}

# Declare the weekdays
days="M T W R F S U"
timestamp=$(date -d "2024-01-01 00:00:00" +"%s")

for week in {1..$weeks}; do

    for day in $days; do
        # Use grep and awk to extract values for the current day
        values=$(echo "$times" | grep -o "${day}([^)]*)" | tr -d "${day}()" | awk '{gsub(/,/, " "); print}')
        # Extract the first value
        starting_status=${values%% *}
        if [ $starting_status = "0" ]; then
            status="FALSE"
        elif [ $starting_status = "1" ]; then
            status="TRUE"
        else
            echo "Invalid value for the starting status, it must be 0 or 1!"
            exit 1
        fi
        # echo "-- Starting status: $status"
        # Remove the first value from the original variable
        values=${values#* }
        # Append a 24:00 at the end as a placeholder for the end of the hours conversion of one day
        values="$values 24:00"
        # Initialize the variable to store the time that has passed until now.
        time_agg=0

        for value in $values; do

            # Convert to seconds the hour when the container status must change.
            hours_2_secs "$value"
            provided_time=$hour_seconds
            # echo "provided_time: $provided_time"
            time_diff=$(($provided_time - $time_agg))
            # This variable indicates the timestamp where the status will change
            threshold_timestamp=$(($timestamp + $time_diff))
            # Aggeregate the current time to the variable
            time_agg=$(($time_agg + $time_diff))

            while [ $threshold_timestamp -gt $timestamp ]; do

                update_status "$timestamp" "$status"
                # Add the sampling interval seconds to the timestamp
                timestamp=$(($timestamp + $sampling_interval))

            done

            if [ $status = "TRUE" ]; then
                status="FALSE"
            elif [ $status = "FALSE" ]; then
                status="TRUE"
            else
                echo "Invalid value for status variable. It must be TRUE or FALSE!"
            fi
            # echo "-- Status: $status"

        done
    done

done

# Unset the database password variable for security reasons
unset PGPASSWORD