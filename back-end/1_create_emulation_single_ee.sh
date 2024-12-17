#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# To get the directory where THIS script is being executed. Useful for nested scripts executions.
SCRIPT_DIR=$(dirname "$0")

# -------------------------------------------------------------------------
# Define different simulations by executing the create_containers.sh script
# -------------------------------------------------------------------------

# -------------------
# Showcase simulation
# -------------------
# $SCRIPT_DIR/create_containers.sh ubuntu 1 5 1 5 eedg noco nose nocl ts 60 \
$SCRIPT_DIR/create_containers.sh ubuntu 1 5 1 5 eedg noco nose nocl 60 \
"M(1,1:00,3:00,5:00,7:00,9:00,11:00,13:00,15:00,17:00,19:00,21:00,23:00)\
-T(0,1:00,11:00)\
-W(1,3:00,11:00,14:00,18:00,23:00)\
-R(0,2:00,11:00,14:00,18:00,23:00)\
-F(1,2:00,11:00,14:00,18:00,22:00)\
-S(0,2:00,10:00)\
-U(0,2:00,10:00,13:00,17:00,21:00)"

# $SCRIPT_DIR/create_containers.sh ubuntu 2 5 2 5 eedg noco nose nocl ts 60 \
$SCRIPT_DIR/create_containers.sh ubuntu 2 5 2 5 eedg noco nose nocl 60 \
"M(1,1:00,3:00,5:00,7:00,9:00,11:00,13:00,15:00,17:00,19:00,21:00,23:00)\
-T(0,1:00,11:00)\
-W(1,3:00,11:00,14:00,18:00,23:00)\
-R(0,2:00,11:00,14:00,18:00,23:00)\
-F(1,2:00,11:00,14:00,18:00,22:00)\
-S(0,2:00,10:00)\
-U(0,2:00,10:00,13:00,17:00,21:00)"
# -------------------

lxc list --fast

# Create temporal_files directory if it does not exist
mkdir -p $SCRIPT_DIR/temporal_files

# Dump containers info into a file
echo "Waiting for 3 seconds for all the container IPs to be available..."
sleep 3
lxc list > "$SCRIPT_DIR/temporal_files/containers_list.tmp"
# Dump containers names into a file
lxc list -c n --format csv > "$SCRIPT_DIR/temporal_files/container_names_list.tmp"

num_cntrs=$(( $(sudo lxc list -f compact | wc -l) - 1 ))
echo "Total number of containers: $num_cntrs"