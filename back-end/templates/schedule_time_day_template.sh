#!/bin/<distr_shell>

# ./schedule_time_day.sh 3600 0 3:00 7:00 15:00 20:00

# Verify total arguments number (it's assumed that the total time is not greater than 24 hours)
if [ $# -lt 2 ]; then
    echo "Uso: $0 [conversion factor (1/60/3600)] [initial state (0/1)] [marca_tiempo1] [marca_tiempo2] [...]"
    exit 1
fi

# Log file.
# log_file="/usr/share/ils/bin/schedule_time.log"

# Function definition
hours_2_secs() {
  local hour=$1
  hours=$(echo "$hour" | awk -F':' '{print $1}')
  mins=$(echo "$hour" | awk -F':' '{print $2}')
  # Calcular la conversion a segundos desde las 00:00 horas hasta la hora proporcionada
  hour_seconds=$(( ($hours * 3600 + $mins * 60) / $conversion_factor ))
  # THE VARIABLE HAS NO PRECISSION FOR TIME LESS THAN A SECOND. INVESTIGATE ON HOW TO DO THIS.
}

# Validate the time factor
if [ "$1" != "1" ] && [ "$1" != "60" ] && [ "$1" != "360" ] && [ "$1" != "600" ] && [ "$1" != "900" ] && [ "$1" != "1800" ] && [ "$1" != "3600" ]; then
    echo "The time factor should be 1, 60, 360, 900, 1800 or 3600."
    exit 1
fi

conversion_factor=$1

shift  # Delete the following argument of the list

# Validate the initial state
if [ "$1" != "0" ] && [ "$1" != "1" ]; then
    echo "The initial state should be 0 or 1."
    exit 1
fi

# Stablish the initial state of the container depending on the variable
if [ "$1" == "0" ]; then
  status="standby" # If = 0; state = standby
else
  status="running" # If = 1; state = running
fi

# echo "[schedule_time_day.sh] - $(date): Init" >> "$log_file"

# Check the current satus of the container
curr_status=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
if [ "$curr_status" != "$status" ]; then
  # Change the container status to the desired status of the container.
  if [ "$status" == "standby" ]; then
    /usr/share/ils/bin/turn_off.sh
    # status="standby"
    # echo "[schedule_time_day.sh] - $(date): Status changed from standby to running." >> "$log_file"
  else
    /usr/share/ils/bin/turn_on.sh
    # status="running"
    # echo "[schedule_time_day.sh] - $(date): Status changed from running to standby." >> "$log_file"
  fi
else
  : # Do nothing
fi

shift  # Delete the following argument of the list

# Variable para calcular que el tiempo total de ejecucion del script sean 24 segundos
final_waiting_time=0

# Bucle para procesar las marcas de tiempo
while [ $# -gt 0 ]; do

    # Obtener la hora proporcionada como argumento
    provided_time=$1

    # Verificar formato de la hora
    if echo "$provided_time" | grep -E '^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$' > /dev/null; then

      hours_2_secs "$provided_time"
      provided_time=$hour_seconds
      # Calculate the time in seconds between arguments (if it's the first arg, $1 - 0)
      time_between_args=$(($provided_time - $final_waiting_time))
      sleep $time_between_args
      # Calculate the total time waiting from the beginning till now
      final_waiting_time=$(($final_waiting_time + $time_between_args))

      # Change container status
      if [ "$status" == "standby" ]; then
        /usr/share/ils/bin/turn_on.sh
        status="running"
        # echo "[schedule_time_day.sh] - $(date): Status changed from standby to running." >> "$log_file"
      else
        /usr/share/ils/bin/turn_off.sh
        status="standby"
        # echo "[schedule_time_day.sh] - $(date): Status changed from running to standby." >> "$log_file"
      fi

      # Move to the next input arg
      shift
    else
      echo "Error. Invalid date format"
      exit 1
    fi
done

hours_2_secs "24:00"

#Verify the times supplied are not greater than 24
if [ $final_waiting_time -ge $hour_seconds ]; then
  echo "Error. Provided time arguments cannot exceed a 24 hours period."
  exit 1
fi

# Wait additional time to totalize 24 seconds
sleep $(($hour_seconds - $final_waiting_time))
# echo "[schedule_time_day.sh] - $(date): End" >> "$log_file"

