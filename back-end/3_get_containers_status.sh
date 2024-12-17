#!/bin/bash

# Execution
# sudo ./3_get_containers_status.sh nodejs-server/config_matrix.txt nodejs-server/matrix_size.txt nodejs-server/time_diff.txt "2024-01-29 17:42:50" 3600

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# Check if the file names are provided as args
if [ "$#" -ne 5 ]; then
   echo "Usage: $0 <matrix status file> <colour status file> <service status file>"
   exit 1
fi

SCRIPT_DIR=$(dirname "$0")

config_matrix_file="$1"
matrix_size_file="$2"
time_diff_file="$3"
time_start="$4"
conversion_factor="$5"

matrix_cols=$(lxc list --fast | awk -F '[-]' '
{
  if ($2 ~ /^[0-9]+$/) {
    if ($2 > max_x) max_x = $2;
  }
}
END {
  print max_x
}') # matrix_rows = The greatest x coordinate of the arguments provided before for "core.sh".

echo "Matrix columns = $matrix_cols"

matrix_rows=$(lxc list --fast | awk -F '[-]' '{print $3}' | awk -F ' ' '
{
  if ($1 > max_x) max_x = $1;
}
END {
  print max_x
}') # matrix_cols = The greatest y coordinate of the arguments provided before for "core.sh".

echo "Matrix rows = $matrix_rows"

# Declare the config matrix, and the matrix size
declare -A matrix_size
declare -A config_matrix

matrix_size[1,1]="rows"
matrix_size[1,2]="cols"
matrix_size[2,1]=$matrix_rows
matrix_size[2,2]=$matrix_cols

# Create temporal_files directory if it does not exist
mkdir -p temporal_files

# Get containers list
containers_list=$(cat "$SCRIPT_DIR/temporal_files/containers_list.tmp")
# Get container names
container_names_list=$(cat "$SCRIPT_DIR/temporal_files/container_names_list.tmp")
# Temporary file to store information
temp_file="$SCRIPT_DIR/temporal_files/temp_file.tmp"

# Remove the known_hosts to avoid man in the middle atack warning.
rm -f ~/.ssh/known_hosts ~/.ssh/known_hosts.old

while true; do

echo "Getting containers status..."

# -----------------------------------------------------------------------------------------------
# Get into each container in a background process in order to get the information from the 
# configuration file.
# -----------------------------------------------------------------------------------------------

# Function to get container info
get_container_info() {
    local cnt_ip="$1"
    # local -n config_matrix_func="$2"
    local j="$2"
    local i="$3"
    local SCRIPT_DIR="$4"
    local container_info=$(lxc exec "$cnt_ip" -- cat "/usr/share/ils/conf/container_info.csv")

    # Make grep parsing in HOST machine:
    # sudo ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa "root@$cnt_ip" "cat /usr/share/ils/conf/container_info.csv"
    # local container_info=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa "root@$cnt_ip" "cat /usr/share/ils/conf/container_info.csv" 2>/dev/null)
    local colour=$(echo "$container_info" | grep "^Colour," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    local service=$(echo "$container_info" | grep "^Service," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    local domain=$(echo "$container_info" | grep "^Domain," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    local status=$(echo "$container_info" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    local battery=$(echo "$container_info" | grep "^Battery," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')

    # Delegate greps execution inside CONTAINERS:
    # local container_info=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa "root@$cnt_ip" "source /root/.profile; /usr/share/ils/bin/get_info.sh")
    # read -r colour service domain status <<< "$container_info"

    # Test it with environment variables instead of reading a config file.

    # We have tried to insert the values of each container in the matrix by parallelizing the process with "&" and "nohup"
    # but it did not work because of the asynchronous behaviour of the bakground processes in bach. It executes the process
    # in a separate subshell so the variable config_matrix is lost between shells. So finally the option to fill first a temp
    # file and then populate the matrix is the best option, with this approach we can send the operations to get information
    # from each container to the background.
    # echo $container_info
    # echo "Before condition."
    # echo "Variable is: $SCRIPT_DR"
    if [ "$status" = "running" ]; then
      # config_matrix_func[$j,$i]="2;$domain;$colour;$service"
      echo "${j}:${i}:2;${domain};${colour};${service};${battery}" >> $SCRIPT_DIR/temporal_files/temp_file.tmp
    else
      # config_matrix_func[$j,$i]="1;$domain;$colour;$service"
      echo "${j}:${i}:1;${domain};${colour};${service};${battery}" >> $SCRIPT_DIR/temporal_files/temp_file.tmp
    fi
}

# Export the function so it's available to xargs
export -f get_container_info

start_matrix_time=$(date +%s%N)

# Clear the contents of the temp file
> "$temp_file"

declare -A config_matrix

# Fill matrix with wholes
for ((i = 1; i < $matrix_rows + 1; i++)); do
    for ((j = 1; j < $matrix_cols + 1; j++)); do
      config_matrix[$j,$i]="0;nodo;noco;nose;noba"
    done
done

declare -a pids

# Iterate over the containers to fill temp file
# echo "$container_names_list" | while IFS= read -r cnt_name; do
while IFS= read -r cnt_name; do
  cnt_ip=$(echo "$containers_list" | awk -v container=$cnt_name '$2 == container {print $6}')
  IFS='-' read -r prefix j i <<< "$cnt_name"
  # get_container_info "$cnt_ip" "$j" "$i" &
  # echo "Variable outside is $SCRIPT_DIR"
  echo "$cnt_name $j $i $SCRIPT_DIR" | xargs -n 4 -P 108 bash -c 'get_container_info "$@"' _ &
  pids+=("$!")
done < <(echo "$container_names_list")

# Wait for all background processes to finish
for pid in "${pids[@]}"; do
  # echo "Background process started with PID: $pid"
  wait $pid
done

# Function to handle Ctrl + C (SIGINT)
cleanup() {
  echo "Caught Ctrl + C, terminating all background processes..."
  for pid in "${pids[@]}"; do
    kill $pid 2>/dev/null
  done
  exit 1
}

# Trap Ctrl + C (SIGINT)
trap cleanup SIGINT

# end_matrix_time=$(date +%s%N)
# elapsed_matrix_time=$((end_matrix_time - start_matrix_time))
# echo "-----------------------------------------------------------"
# echo "Time to fill temp file: $elapsed_matrix_time nanoseconds."
# echo "-----------------------------------------------------------"

start_read_time=$(date +%s%N)

# echo "temp_file lines: `cat temp_file | wc -l`"
# Read from the temp file and populate the matrix
while IFS= read -r line; do
    IFS=':' read -ra parts <<< "$line"
    j="${parts[0]}"
    i="${parts[1]}"
    data="${parts[2]}"
    config_matrix[$j,$i]="$data"
done < "$temp_file"

# Start measuring time
start_temp_time=$(date +%s%N)

# Save the configuration matrix into a file
# echo "Storing in [$config_matrix_file] file..."
> "$config_matrix_file"  # Create or overwrite the file
for ((i = $matrix_rows; i > 0; i--)); do
  line=""
  for ((j = 1; j < $matrix_cols + 1; j++)); do
    line+=" ${config_matrix[$j,$i]}"
  done
  echo "$line" >> "$config_matrix_file"
done

# Calculate the fake time to print in GUI:
# Convert date strings to timestamps
time_start_ttmp=$(date -d "$time_start" +"%s")
curr_date_ttmp=$(date +"%s")

time_diff=$((curr_date_ttmp - time_start_ttmp))

if [ $time_diff -le 0 ]; then

  formatted_time_diff=$(printf "%d:%02d:%02d" $((time_diff / 3600)) $(( (time_diff % 3600) / 60 )) $((time_diff % 60)))

else

  # Each second in the real time corresponds with one hour in the emulation.
  if [ $conversion_factor -eq 3600 ]; then
    # One hour more each second:
    current_hour=$((time_diff % 24))
    # One day more each time the time passes 24 seconds, and start again when arrive to 7, starting in week 1 (because of that, the +1):
    current_day=$(( ((time_diff / 24) % 7 ) +1))
    # One week more each time the time passes 24·7=168 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 168) +1))
    formatted_time_diff="$current_hour:00:00"
  # Each second in the real time corresponds with half an hour in the emulation.
  elif [ $conversion_factor -eq 1800 ]; then
    # One hour more each two seconds:
    current_hour=$((time_diff/2 % 24))
    # Minutes are 30 or 00:
    min_condition=$((time_diff % 2))
    if [ $min_condition -eq 0 ]; then
      current_min=00
    else
      current_min=30
    fi
    # One day more each time the time passes 24 seconds, and start again when arrive to 7, starting in week 1 (because of that, the +1):
    current_day=$(( ((time_diff / 48) % 7 ) +1))
    # One week more each time the time passes 24·7=168 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 336) +1))
    formatted_time_diff="$current_hour:$current_min:00"
  # Each second in the real time corresponds with half an hour in the emulation.
  elif [ $conversion_factor -eq 900 ]; then
    # One hour more each two seconds:
    current_hour=$((time_diff/4 % 24))
    # Minutes are 30 or 00:
    min_condition=$((time_diff % 4))
    if [ $min_condition -eq 0 ]; then
      current_min=00
    elif [ $min_condition -eq 1 ]; then
      current_min=25
    elif [ $min_condition -eq 2 ]; then
      current_min=30
    elif [ $min_condition -eq 3 ]; then
      current_min=45
    fi
    # One day more each time the time passes 24 seconds, and start again when arrive to 7, starting in week 1 (because of that, the +1):
    current_day=$(( ((time_diff / 96) % 7 ) +1))
    # One week more each time the time passes 24·7=168 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 672) +1))
    formatted_time_diff="$current_hour:$current_min:00"
  # Each second in the real time corresponds with half an hour in the emulation.
  elif [ $conversion_factor -eq 600 ]; then
    # One hour more each two seconds:
    current_hour=$((time_diff/6 % 24))
    # Minutes are 30 or 00:
    min_condition=$((time_diff % 6))
    if [ $min_condition -eq 0 ]; then
      current_min=00
    elif [ $min_condition -eq 1 ]; then
      current_min=10
    elif [ $min_condition -eq 2 ]; then
      current_min=20
    elif [ $min_condition -eq 3 ]; then
      current_min=30
    elif [ $min_condition -eq 4 ]; then
      current_min=40
    elif [ $min_condition -eq 5 ]; then
      current_min=50
    fi
    # One day more each time the time passes 24 seconds, and start again when arrive to 7, starting in week 1 (because of that, the +1):
    current_day=$(( ((time_diff / 144) % 7 ) +1))
    # One week more each time the time passes 24·7=168 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 1008) +1))
    formatted_time_diff="$current_hour:$current_min:00"
  # Each second in the real time corresponds with six minutes in the emulation.
  elif [ $conversion_factor -eq 360 ]; then
    # One hour more each two seconds:
    current_hour=$((time_diff/10 % 24))
    # Minutes are 30 or 00:
    min_condition=$((time_diff % 10))
    if [ $min_condition -eq 0 ]; then
      current_min=00
    elif [ $min_condition -eq 1 ]; then
      current_min=06
    elif [ $min_condition -eq 2 ]; then
      current_min=12
    elif [ $min_condition -eq 3 ]; then
      current_min=18
    elif [ $min_condition -eq 4 ]; then
      current_min=24
    elif [ $min_condition -eq 5 ]; then
      current_min=30
    elif [ $min_condition -eq 6 ]; then
      current_min=36
    elif [ $min_condition -eq 7 ]; then
      current_min=42
    elif [ $min_condition -eq 8 ]; then
      current_min=48
    elif [ $min_condition -eq 9 ]; then
      current_min=54
    fi
    # One day more each time the time passes 24 seconds, and start again when arrive to 7, starting in week 1 (because of that, the +1):
    current_day=$(( ((time_diff / 240) % 7 ) +1))
    # One week more each time the time passes 24·7=168 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 1680) +1))
    formatted_time_diff="$current_hour:$current_min:00"
  # Each second in the real time corresponds with one minute in the emulation.
  elif [ $conversion_factor -eq 60 ]; then
    # Each time 60 seconds pass, is equal to one hour in the emulation, so sum 1 until it arrives to 24 that it starts again:
    current_hour=$(( (time_diff / 60) % 24 ))
    # Minutes equal to seconds in the emulation:
    current_min=$((time_diff % 60))
    # One day more each time the time passes 60·24=1440 seconds, and start again when arrive to 7, starting in day 1 (because of that, the +1):
    current_day=$(( ((time_diff / 1440) % 7 ) +1))
    # One week more each time the time passes 60·24·7=10080 seconds, starting in week 1 (because of that, the +1):
    current_week=$(((time_diff / 10080) +1))
    formatted_time_diff="$current_hour:$current_min:00"
  # Same time in the reality and in the emulation.
  elif [ $conversion_factor -eq 1 ]; then
    # Convert the time difference to "0:00:00" format
    formatted_time_diff=$(printf "%d:%02d:%02d" $((time_diff / 3600)) $(( (time_diff % 3600) / 60 )) $((time_diff % 60)))
  else
    formatted_time_diff="00:00:00"
  fi

fi

> "$time_diff_file"  # Create or overwrite the file
echo "Week:$current_week--Day:$current_day--$formatted_time_diff" > $time_diff_file

# echo "Time difference: $formatted_time_diff"

# Save the matrix size into a file
# echo "Storing in [$matrix_size_file] file..."
> "$matrix_size_file"  # Create or overwrite the file
for ((i = 1; i < 3; i++)); do
  for ((j = 1; j < 3; j++)); do
      echo -n "${matrix_size[$j,$i]} " >> "$matrix_size_file"
  done
  echo "" >> "$matrix_size_file"
done

# End measuring time
end_temp_time=$(date +%s%N)
# elapsed_temp_time=$((end_temp_time - start_temp_time))
# echo "----------------------------------------------------"
# echo "Time to fill matrix: $elapsed_temp_time nanoseconds."
# echo "----------------------------------------------------"

elapsed_time=$(( (end_temp_time - start_matrix_time) / 1000000000 ))
echo "-----------------------------------------------------------"
echo "Time to complete the loop: $elapsed_time seconds."
echo "-----------------------------------------------------------"

done
