#!/bin/bash

# ./4_generate_ground_truth_data.sh 30 1 25 180

sampling_interval=$1
weeks=$2
containers=$3
# This input arg indicates the seconds after the DNN is going to predict (in minutes):
predict_interval=$4

# Database connection details
#----------------------------
DB_NAME="ile"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="localhost"
DB_PORT="5432"
TABLE_NAME_TIMESERIES=ILE_TIMESERIES
#----------------------------

# Export the password to avoid being prompted
export PGPASSWORD="$DB_PASSWORD"

# Declare a variable with the seconds of an entire week 24 (hours) * 3600 (secs) * 7 (days)
week_in_secs=604800
# Declare the initial timestamp
initial_timestamp=$(date -d "2024-01-01 00:00:00" +%s)
# Convert the weeks to be added to seconds:
weeks_to_sum=$((week_in_secs * weeks))
# Calculate the final timestamp
end_timestamp=$((initial_timestamp + weeks_to_sum))
# end_timestamp=$(date -d @$end_timestamp +"%Y-%m-%d %H:%M:%S")

# Convert predict interval to seconds:
predict_interval=$((predict_interval * 60))

# Declare the variable to stop the second for loop intended to fill the ground truth values starting from the beginning.
beginning_stop_timestamp=$((initial_timestamp + predict_interval))

for ((i = 1; i <= containers; i++))
do
    # The initial ground truth timestamp
    current_gt_timestamp=$((initial_timestamp + predict_interval))
    # The initial current timestamp
    current_timestamp=$initial_timestamp
    # First while loop for inserting data till having to get the ground truth values from the beginning.
    while [ $current_gt_timestamp -lt $end_timestamp ]; do
        # Convert both timestamps variables to timestamp format for filtering the query
        current_timestamp_tmp=$(date -d @$current_timestamp +"%Y-%m-%d %H:%M:%S")
        current_gt_timestamp_tmp=$(date -d @$current_gt_timestamp +"%Y-%m-%d %H:%M:%S")
        # Query using heredoc.
sql_command=$(cat <<EOF
UPDATE $TABLE_NAME_TIMESERIES
SET ground_truth = (
    SELECT status
    FROM $TABLE_NAME_TIMESERIES
    WHERE container_id = '$i'
    AND timestamp = '$current_gt_timestamp_tmp'
)
WHERE container_id = '$i'
AND timestamp = '$current_timestamp_tmp';
EOF
        )
        psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$sql_command"
        # Calculate the next ground truth timestamp
        current_gt_timestamp=$((current_gt_timestamp + sampling_interval))
        # Calculate the next current timestamp
        current_timestamp=$((current_timestamp + sampling_interval))
    done
    current_gt_timestamp=$initial_timestamp
    # Second while loop to fill the ground truth values starting from the beginning.
    while [ $current_timestamp -lt $end_timestamp ]; do
        # Convert both timestamps variables to timestamp format for filtering the query
        current_timestamp_tmp=$(date -d @$current_timestamp +"%Y-%m-%d %H:%M:%S")
        current_gt_timestamp_tmp=$(date -d @$current_gt_timestamp +"%Y-%m-%d %H:%M:%S")
        # Query using heredoc.
sql_command=$(cat <<EOF
UPDATE $TABLE_NAME_TIMESERIES
SET ground_truth = (
    SELECT status
    FROM $TABLE_NAME_TIMESERIES
    WHERE container_id = '$i'
    AND timestamp = '$current_gt_timestamp_tmp'
)
WHERE container_id = '$i'
AND timestamp = '$current_timestamp_tmp';
EOF
        )
        psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$sql_command"
        # Calculate the next ground truth timestamp
        current_gt_timestamp=$((current_gt_timestamp + sampling_interval))
        # Calculate the next current timestamp
        current_timestamp=$((current_timestamp + sampling_interval))
    done
done

# Unset the database password variable for security reasons
unset PGPASSWORD