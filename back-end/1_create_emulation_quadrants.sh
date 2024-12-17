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
$SCRIPT_DIR/create_containers.sh alpine 1 5 1 5 eedg noco nose nocl 360 40 Y \
"M(0,3:00,6:00,15:00,18:00)\
-T(0,3:00,6:00,15:00,18:00)\
-W(0,3:00,6:00,15:00,18:00)\
-R(0,3:00,6:00,15:00,18:00)\
-F(0,3:00,6:00,15:00,18:00)\
-S(0,3:00,6:00,15:00,18:00)\
-U(0,3:00,6:00,15:00,18:00)"
$SCRIPT_DIR/create_containers.sh alpine 1 13 1 13 eedg noco nose nocl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh alpine 4 2 4 2 eedg noco nose nocl 360 40 Y \
"M(0,3:00,6:00,15:00,18:00)\
-T(0,3:00,6:00,15:00,18:00)\
-W(0,3:00,6:00,15:00,18:00)\
-R(0,3:00,6:00,15:00,18:00)\
-F(0,3:00,6:00,15:00,18:00)\
-S(0,3:00,6:00,15:00,18:00)\
-U(0,3:00,6:00,15:00,18:00)"
$SCRIPT_DIR/create_containers.sh alpine 5 17 5 17 eedg noco nose nocl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh alpine 5 19 5 19 eedg noco nose nocl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 6 9 6 9 eedg noco nose cl 360 40 Y \
"M(0,3:00,6:00,15:00,18:00)\
-T(0,3:00,6:00,15:00,18:00)\
-W(0,3:00,6:00,15:00,18:00)\
-R(0,3:00,6:00,15:00,18:00)\
-F(0,3:00,6:00,15:00,18:00)\
-S(0,3:00,6:00,15:00,18:00)\
-U(0,3:00,6:00,15:00,18:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 6 11 6 11 eedg noco nose cl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh alpine 7 4 7 4 eedg noco nose cl 360 40 Y \
"M(0,3:00,6:00,15:00,18:00)\
-T(0,3:00,6:00,15:00,18:00)\
-W(0,3:00,6:00,15:00,18:00)\
-R(0,3:00,6:00,15:00,18:00)\
-F(0,3:00,6:00,15:00,18:00)\
-S(0,3:00,6:00,15:00,18:00)\
-U(0,3:00,6:00,15:00,18:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 8 7 8 7 eedg noco nose cl 360 40 Y \
"M(0,3:00,6:00,15:00,18:00)\
-T(0,3:00,6:00,15:00,18:00)\
-W(0,3:00,6:00,15:00,18:00)\
-R(0,3:00,6:00,15:00,18:00)\
-F(0,3:00,6:00,15:00,18:00)\
-S(0,3:00,6:00,15:00,18:00)\
-U(0,3:00,6:00,15:00,18:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 8 15 8 15 eedg noco nose cl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh alpine 8 21 8 21 eedg noco nose nocl 360 40 Y \
"M(1,3:00,12:00,15:00)\
-T(1,3:00,12:00,15:00)\
-W(1,3:00,12:00,15:00)\
-R(1,3:00,12:00,15:00)\
-F(1,3:00,12:00,15:00)\
-S(1,3:00,12:00,15:00)\
-U(1,3:00,12:00,15:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 10 11 10 11 core purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 10 12 10 12 core purp nose nocl
$SCRIPT_DIR/create_containers.sh ubuntu 11 8 11 8 eedg noco nose cl 360 40 Y \
"M(0,6:00,9:00,18:00,21:00)\
-T(0,6:00,9:00,18:00,21:00)\
-W(0,6:00,9:00,18:00,21:00)\
-R(0,6:00,9:00,18:00,21:00)\
-F(0,6:00,9:00,18:00,21:00)\
-S(0,6:00,9:00,18:00,21:00)\
-U(0,6:00,9:00,18:00,21:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 11 10 11 10 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh ubuntu 11 11 11 11 core purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 11 12 11 12 core purp nose nocl
$SCRIPT_DIR/create_containers.sh ubuntu 11 14 11 14 eedg noco nose cl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 11 19 11 19 eedg noco nose cl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 12 5 12 5 eedg noco nose cl 360 40 Y \
"M(0,6:00,9:00,18:00,21:00)\
-T(0,6:00,9:00,18:00,21:00)\
-W(0,6:00,9:00,18:00,21:00)\
-R(0,6:00,9:00,18:00,21:00)\
-F(0,6:00,9:00,18:00,21:00)\
-S(0,6:00,9:00,18:00,21:00)\
-U(0,6:00,9:00,18:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 12 10 12 10 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 12 11 12 11 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 12 18 12 18 eedg noco nose nocl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 13 10 13 10 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 13 11 13 11 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh alpine 13 12 13 12 edge purp nose nocl
$SCRIPT_DIR/create_containers.sh ubuntu 13 15 13 15 eedg noco nose cl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 14 8 14 8 eedg noco nose cl 360 40 Y \
"M(0,6:00,9:00,18:00,21:00)\
-T(0,6:00,9:00,18:00,21:00)\
-W(0,6:00,9:00,18:00,21:00)\
-R(0,6:00,9:00,18:00,21:00)\
-F(0,6:00,9:00,18:00,21:00)\
-S(0,6:00,9:00,18:00,21:00)\
-U(0,6:00,9:00,18:00,21:00)"
$SCRIPT_DIR/create_containers.sh ubuntu 15 10 15 10 eedg noco nose cl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 15 17 15 17 eedg noco nose nocl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 16 6 16 6 eedg noco nose nocl 360 40 Y \
"M(0,6:00,9:00,18:00,21:00)\
-T(0,6:00,9:00,18:00,21:00)\
-W(0,6:00,9:00,18:00,21:00)\
-R(0,6:00,9:00,18:00,21:00)\
-F(0,6:00,9:00,18:00,21:00)\
-S(0,6:00,9:00,18:00,21:00)\
-U(0,6:00,9:00,18:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 16 14 16 14 eedg noco nose nocl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 16 20 16 20 eedg noco nose nocl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 17 2 17 2 eedg noco nose cl 360 40 Y \
"M(0,6:00,9:00,18:00,21:00)\
-T(0,6:00,9:00,18:00,21:00)\
-W(0,6:00,9:00,18:00,21:00)\
-R(0,6:00,9:00,18:00,21:00)\
-F(0,6:00,9:00,18:00,21:00)\
-S(0,6:00,9:00,18:00,21:00)\
-U(0,6:00,9:00,18:00,21:00)"
$SCRIPT_DIR/create_containers.sh alpine 19 10 19 10 eedg noco nose nocl 360 40 Y \
"M(0,9:00,12:00,21:00)\
-T(0,9:00,12:00,21:00)\
-W(0,9:00,12:00,21:00)\
-R(0,9:00,12:00,21:00)\
-F(0,9:00,12:00,21:00)\
-S(0,9:00,12:00,21:00)\
-U(0,9:00,12:00,21:00)"
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