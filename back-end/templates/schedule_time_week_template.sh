#!/bin/<distr_shell>

# ./shedule_time_week.sh 3600 "M(0,3:00,7:00,15:00,20:00)-T(0,2:00,12:00)-W(0,2:00,12:00)-R(0,2:00,12:00)-F(0,2:00,12:00)-S(0,2:00,12:00)-U(0,2:00,12:00)" "17:42:50"

# Verify total arguments number.
if [ $# -lt 2 ]; then
    echo "Usage: $0 [conversion factor (1/60/1800/3600)] [initial state (0/1)] [timestamp1] [timestamp2] [...]"
    exit 1
fi

conversion_factor=$1
times=$2
time_start=$3

# Convert the time when the emulation must start to seconds.
time_start_ttmp=$(date -d "$time_start" +"%s")
# Convert the current time to seconds.
curr_date_ttmp=$(date +"%s")

# Calculate the difference between both.
time_diff=$((time_start_ttmp - curr_date_ttmp))

# Wait until the the current time is equal to the emulation start time.
sleep $time_diff

# Log file.
# log_file="/usr/share/ils/bin/schedule_time.log"

# Set values for each week day.
days="M T W R F S U"
cntr=1

while true; do

    for day in $days; do
        # Use grep and awk to extract values for the current day
        values=$(echo "$times" | grep -o "${day}([^)]*)" | tr -d "${day}()" | awk '{gsub(/,/, " "); print}')
        /usr/share/ils/bin/schedule_time_day.sh "$conversion_factor" $values
        # Collect the background process ID
        # pids+=("$!")
        # pids="$pids $!"
        # echo "[shedule_time_week.sh] - Day "$day" for iteration $cntr finished." >> "$log_file"
    done

    # Wait for all background processes to finish
    # wait $pids
    # wait
    cntr=$((cntr + 1))

done