#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# -------------------------------------------------------------------------
# Define different simulations by executing the create_containers.sh script
# -------------------------------------------------------------------------

# -------------------
# Showcase simulation
# -------------------
# See the "create_containers.sh" script for more clarification on the usage.
./create_containers.sh alpine 1 1 1 1 eedg noco nose nocl 3600 \
"M(1,1:00,6:00,9:00,17:00)\
-T(1,2:00,8:00,11:00,23:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(1,3:00,11:00)\
-S(0,2:00,10:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 1 5 1 5 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 2 2 2 2 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 2 9 2 9 eedg noco nose nocl 3600 \
"M(1,2:00,4:00,11:00,17:00)\
-T(1,1:00,11:00)\
-W(0,3:00,11:00,15:00,19:00,23:00)\
-R(1,1:00,9:00)\
-F(1,4:00,10:00,15:00,19:00,23:00)\
-S(0,2:00,10:00)\
-U(1,1:00,10:00,13:00,18:00,22:00)"
./create_containers.sh alpine 2 12 2 12 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,20:00)\
-T(1,0:00,11:00)\
-W(0,3:00,11:00,14:00,18:00,23:00)\
-R(1,2:00,10:00)\
-F(0,3:00,10:00,13:00,17:00,21:00)\
-S(0,2:00,10:00)\
-U(0,2:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 2 18 2 18 eedg noco nose nocl 3600 \
"M(1,2:00,7:00,16:00,19:00)\
-T(0,1:00,11:00)\
-W(1,3:00,11:00,14:00,18:00,23:00)\
-R(0,2:00,11:00,14:00,18:00,23:00)\
-F(1,2:00,11:00,14:00,18:00,22:00)\
-S(0,2:00,10:00)\
-U(0,2:00,10:00,13:00,17:00,21:00)"
./create_containers.sh alpine 4 7 4 7 eedg noco nose nocl 3600 \
"M(1,5:00,7:00,12:00,16:00,20:00)\
-T(0,3:00,11:00,14:00,19:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(0,3:00,10:00)\
-S(1,2:00,11:00)\
-U(1,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 4 12 4 12 eedg noco nose nocl 3600 \
"M(1,2:00,6:00,14:00,18:00)\
-T(1,0:00,12:00)\
-W(1,2:00,12:00)\
-R(0,2:00,4:00,12:00,16:00,21:00)\
-F(1,2:00,10:00)\
-S(0,2:00,4:00,12:00,16:00,21:00)\
-U(0,1:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 4 16 4 16 eedg noco nose nocl 3600 \
"M(1,2:00,5:00,15:00,19:00)\
-T(1,2:00,11:00)\
-W(0,3:00,12:00)\
-R(1,2:00,10:00)\
-F(1,2:00,11:00)\
-S(0,1:00,11:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 6 8 6 8 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 6 11 6 11 eedg noco nose nocl 3600 \
"M(1,2:00,7:00,15:00,19:00)\
-T(0,3:00,11:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(0,3:00,9:00,13:00,19:00)\
-S(0,3:00,9:00,12:00,19:00)\
-U(1,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 7 4 7 4 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 7 14 7 14 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 8 6 8 6 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,20:00)\
-T(1,0:00,11:00)\
-W(0,3:00,11:00,14:00,18:00,23:00)\
-R(1,2:00,10:00)\
-F(0,3:00,10:00,13:00,17:00,21:00)\
-S(0,2:00,10:00)\
-U(0,2:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 8 8 8 8 eedg noco nose nocl 3600 \
"M(1,2:00,6:00,14:00,18:00)\
-T(1,0:00,12:00)\
-W(1,2:00,12:00)\
-R(0,2:00,12:00)\
-F(1,2:00,10:00)\
-S(1,2:00,12:00)\
-U(0,1:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 8 18 8 18 eedg noco nose nocl 3600 \
"M(1,1:00,6:00,9:00,17:00)\
-T(1,1:00,11:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(1,3:00,11:00)\
-S(0,2:00,10:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 9 3 9 3 eedg noco nose nocl 3600 \
"M(0,4:00,14:00,22:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(0,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 9 14 9 14 eedg noco nose nocl 3600 \
"M(1,2:00,7:00,15:00,19:00)\
-T(0,3:00,11:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(0,3:00,10:00)\
-S(1,2:00,11:00)\
-U(1,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 11 6 11 6 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,20:00)\
-T(1,0:00,11:00)\
-W(0,3:00,11:00,14:00,18:00,23:00)\
-R(1,2:00,10:00)\
-F(0,3:00,10:00,13:00,17:00,21:00)\
-S(0,2:00,10:00)\
-U(0,2:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 11 12 11 12 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00)\
-T(1,0:00,11:00,14:00,22:00)\
-W(1,3:00,7:00,16:00,23:00)\
-R(1,2:00,10:00,13:00,19:00)\
-F(1,3:00,10:00,13:00)\
-S(0,2:00,10:00)\
-U(0,2:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 12 14 12 14 edge cyan nose nocl
./create_containers.sh alpine 12 15 12 15 edge cyan nose nocl
./create_containers.sh alpine 12 18 12 18 eedg noco nose nocl 3600 \
"M(1,2:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(1,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 13 10 13 10 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00)\
-T(1,0:00,11:00,14:00,22:00)\
-W(1,3:00,7:00,16:00,23:00)\
-R(1,2:00,10:00,13:00,19:00)\
-F(1,3:00,10:00,13:00)\
-S(0,2:00,10:00)\
-U(0,2:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 13 14 13 14 edge cyan nose nocl
./create_containers.sh alpine 13 15 13 15 edge cyan nose nocl
./create_containers.sh alpine 13 16 13 16 edge cyan nose nocl
./create_containers.sh alpine 14 3 14 3 eedg noco srv1 nocl 3600 \
"M(1,1:00,6:00,9:00,17:00)\
-T(1,1:00,11:00)\
-W(1,3:00,11:00)\
-R(1,2:00,10:00)\
-F(1,3:00,11:00)\
-S(0,2:00,10:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 14 4 14 4 eedg noco srv1 nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 14 6 14 6 eedg noco srv1 nocl 3600 \
"M(1,2:00,4:00,11:00,17:00)\
-T(1,1:00,11:00)\
-W(0,3:00,11:00,15:00,19:00,23:00)\
-R(1,1:00,9:00)\
-F(1,4:00,10:00,15:00,19:00,23:00)\
-S(0,2:00,10:00)\
-U(1,1:00,10:00,13:00,18:00,22:00)"
./create_containers.sh alpine 14 14 14 14 edge cyan nose nocl
./create_containers.sh alpine 14 15 14 15 edge cyan nose nocl
./create_containers.sh alpine 15 6 15 6 eedg noco nose nocl 3600 \
"M(1,1:00,7:00,12:00,18:00)\
-T(1,1:00,11:00)\
-W(0,2:00,12:00,14:00,18:00,22:00)\
-R(1,1:00,9:00)\
-F(1,2:00,10:00,15:00,20:00,23:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 15 14 15 14 edge cyan nose nocl
./create_containers.sh alpine 15 15 15 15 edge cyan nose nocl
./create_containers.sh alpine 16 10 16 10 eedg noco nose nocl 3600 \
"M(0,2:00,12:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(0,2:00,12:00)"
./create_containers.sh alpine 16 14 16 14 core cyan srv1 nocl
./create_containers.sh alpine 16 15 16 15 core cyan nose nocl
./create_containers.sh alpine 16 18 16 18 edge cyan nose nocl
./create_containers.sh alpine 17 5 17 5 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,12:00,18:00)\
-T(1,1:00,11:00)\
-W(1,2:00,12:00,14:00,18:00,22:00)\
-R(1,1:00,9:00)\
-F(0,2:00,10:00,15:00,20:00,23:00)\
-S(1,2:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 17 13 17 13 core cyan nose nocl
./create_containers.sh alpine 17 14 17 14 core cyan nose nocl
./create_containers.sh alpine 17 15 17 15 core cyan srv1 nocl
./create_containers.sh alpine 17 16 16 17 edge cyan nose nocl # Probar a juntar con la línea de abajo
./create_containers.sh alpine 17 17 17 17 edge cyan nose nocl
./create_containers.sh alpine 18 8 18 8 eedg noco nose nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 18 14 18 14 core cyan nose nocl
./create_containers.sh alpine 18 15 18 15 core cyan nose nocl
./create_containers.sh alpine 18 18 18 18 edge cyan nose nocl
./create_containers.sh alpine 19 3 19 3 eedg noco nose nocl 3600 \
"M(1,2:00,7:00,16:00,19:00)\
-T(0,1:00,11:00)\
-W(1,3:00,11:00,14:00,18:00,23:00)\
-R(0,2:00,11:00,14:00,18:00,23:00)\
-F(1,2:00,11:00,14:00,18:00,22:00)\
-S(0,2:00,10:00)\
-U(0,2:00,10:00,13:00,17:00,21:00)"
./create_containers.sh alpine 19 11 19 11 eedg noco nose nocl 3600 \
"M(1,1:00,8:00,15:00,19:00)\
-T(1,3:00,11:00)\
-W(0,4:00,12:00,14:00,18:00,23:00)\
-R(1,2:00,11:00)\
-F(0,1:00,11:00,14:00,18:00,22:00)\
-S(1,2:00,11:00,14:00,18:00,22:00)\
-U(0,1:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 20 2 20 2 eedg noco nose nocl 3600 \
"M(0,4:00,14:00,22:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(0,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 20 11 20 11 eedg noco nose nocl 3600 \
"M(0,4:00,14:00,22:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(0,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 21 5 21 5 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,5:00,12:00,13:00,18:00)"
./create_containers.sh alpine 21 9 21 9 eedg noco nose nocl 3600 \
"M(0,4:00,14:00,22:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(0,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 21 11 21 11 eedg noco nose nocl 3600 \
"M(0,2:00,5:00,9:00,11:00,17:00,22:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,4:00,15:00,21:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 21 15 21 15 eedg noco nose nocl 3600 \
"M(0,2:00,9:00,15:00,21:00)\
-T(9:00,11:00,17:00,22:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,4:00,15:00,21:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 21 17 21 17 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(9:00,11:00,17:00,22:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,5:00,12:00,13:00,18:00)"
./create_containers.sh alpine 22 7 22 7 eedg noco nose nocl 3600 \
"M(0,2:00,9:00,15:00,21:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,5:00,12:00,13:00,18:00)"
./create_containers.sh alpine 22 12 22 12 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,15:00,20:00)\
-T(1,2:00,11:00,16:00,22:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(2:00,12:00,13:00,17:00,22:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,2:00,7:00,15:00,20:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 22 15 22 15 eedg noco nose nocl 3600 \
"M(0,2:00,9:00,15:00,21:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 24 11 24 11 core purp nose nocl
./create_containers.sh alpine 25 3 25 3 eedg noco nose nocl 3600 \
"M(1,3:00,7:00,15:00,20:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(1,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 25 8 25 8 edge purp nose nocl
./create_containers.sh alpine 25 9 25 9 edge purp nose nocl
./create_containers.sh alpine 25 10 25 10 core purp srv2 nocl
./create_containers.sh alpine 25 11 25 11 core purp srv2 nocl
./create_containers.sh alpine 25 12 25 12 core purp nose nocl
./create_containers.sh alpine 25 13 25 13 edge purp nose nocl
./create_containers.sh alpine 25 14 25 14 edge purp nose nocl
./create_containers.sh alpine 25 18 25 18 eedg noco srv2 nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 26 9 26 9 edge purp nose nocl
./create_containers.sh alpine 26 10 26 10 edge purp nose nocl
./create_containers.sh alpine 26 11 26 11 core purp nose nocl
./create_containers.sh alpine 26 12 26 12 core purp nose nocl
./create_containers.sh alpine 26 13 26 13 edge purp srv2 nocl
./create_containers.sh alpine 26 14 26 14 edge purp srv2 nocl
./create_containers.sh alpine 26 18 26 18 eedg noco srv2 nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 27 10 27 10 edge purp nose nocl
./create_containers.sh alpine 27 13 27 13 edge purp nose nocl
./create_containers.sh alpine 27 14 27 14 edge purp nose nocl
./create_containers.sh alpine 27 15 27 15 edge purp nose nocl
./create_containers.sh alpine 28 5 28 5 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,15:00,20:00)\
-T(1,2:00,11:00,16:00,22:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(2:00,12:00,13:00,17:00,22:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,2:00,7:00,15:00,20:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 29 17 29 17 eedg noco nose nocl 3600 \
"M(0,2:00,9:00,15:00,21:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,5:00,12:00,13:00,18:00)"
./create_containers.sh alpine 30 3 30 3 eedg noco srv3 nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(0,2:00,12:00,18:00)"
./create_containers.sh alpine 30 6 30 6 eedg noco srv3 nocl 3600 \
"M(0,3:00,10:00,15:00,20:00,23:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(0,6:00,11:00)"
./create_containers.sh alpine 30 8 30 8 eedg noco nose nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(1,3:00,19:00)"
./create_containers.sh alpine 31 3 31 3 eedg noco srv3 nocl 3600 \
"M(1,2:00,7:00,15:00,20:00)\
-T(1,2:00,12:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(1,2:00,9:00,11:00,14:00,18:00)\
-F(1,3:00,10:00,15:00,20:00,23:00)\
-S(1,3:00,11:00,14:00,18:00,22:00,23:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 31 8 31 8 eedg noco nose nocl 3600 \
"M(0,2:00,12:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(0,2:00,12:00)"
./create_containers.sh alpine 31 13 31 13 eedg noco nose nocl 3600 \
"M(0,2:00,7:00,15:00,20:00)\
-T(1,2:00,11:00,16:00,22:00)\
-W(1,3:00,12:00,14:00,18:00,22:00)\
-R(2:00,12:00,13:00,17:00,22:00)\
-F(0,3:00,10:00,15:00,20:00,23:00)\
-S(1,2:00,7:00,15:00,20:00)\
-U(0,2:00,12:00,13:00,17:00,22:00)"
./create_containers.sh alpine 31 14 31 14 eedg noco nose nocl 3600 \
"M(0,3:00,7:00,15:00,20:00)\
-T(0,2:00,12:00)\
-W(0,2:00,12:00)\
-R(0,2:00,12:00)\
-F(0,2:00,12:00)\
-S(0,2:00,12:00)\
-U(0,2:00,12:00)"
./create_containers.sh alpine 31 15 31 15 eedg noco nose nocl 3600 \
"M(1,2:00,6:00,14:00,18:00)\
-T(1,0:00,12:00)\
-W(1,2:00,12:00)\
-R(0,2:00,4:00,12:00,16:00,21:00)\
-F(1,2:00,10:00)\
-S(0,2:00,4:00,12:00,16:00,21:00)\
-U(0,1:00,11:00,14:00,18:00,23:00)"
./create_containers.sh alpine 33 6 33 6 edge cyan nose nocl
./create_containers.sh alpine 33 7 33 7 core cyan nose nocl
./create_containers.sh alpine 33 8 33 8 core cyan nose nocl
./create_containers.sh alpine 33 9 33 9 edge cyan nose nocl
./create_containers.sh alpine 34 4 34 4 edge cyan srv3 nocl
./create_containers.sh alpine 34 5 34 5 edge cyan srv3 nocl
./create_containers.sh alpine 34 6 34 6 core cyan srv3 nocl
./create_containers.sh alpine 34 7 34 7 core cyan nose nocl
./create_containers.sh alpine 34 8 34 8 core cyan nose nocl
./create_containers.sh alpine 34 9 34 9 edge cyan nose nocl
./create_containers.sh alpine 34 10 34 10 edge cyan nose nocl
./create_containers.sh alpine 34 11 34 11 edge cyan nose nocl
./create_containers.sh alpine 35 6 35 6 edge cyan nose nocl
./create_containers.sh alpine 35 7 35 7 core cyan nose nocl
./create_containers.sh alpine 35 8 35 8 core cyan nose nocl
# -------------------

lxc list --fast

# Create temporal_files directory if it does not exist
mkdir -p temporal_files

# Dump containers info into a file
echo "Waiting for 3 seconds for all the container IPs to be available..."
sleep 3
lxc list > "temporal_files/containers_list.tmp"
# Dump containers names into a file
lxc list -c n --format csv > "temporal_files/container_names_list.tmp"

num_cntrs=$(lxc list --fast | grep -c alpine)
echo "Total number of containers: $num_cntrs"