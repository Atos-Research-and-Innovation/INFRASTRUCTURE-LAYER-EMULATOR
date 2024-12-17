#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# To get the directory where THIS script is being executed. Useful for nested scripts executions.
SCRIPT_DIR=$(dirname "$0")

$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-1-5 \
"M(0,3:00,12:00)\
-T(0,3:00,12:00)\
-W(0,3:00,12:00)\
-R(0,3:00,12:00)\
-F(0,3:00,12:00)\
-S(0,3:00,12:00)\
-U(0,3:00,12:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-1-13 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-4-2 \
"M(0,3:00,12:00)\
-T(0,3:00,12:00)\
-W(0,3:00,12:00)\
-R(0,3:00,12:00)\
-F(0,3:00,12:00)\
-S(0,3:00,12:00)\
-U(0,3:00,12:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-5-17 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-5-19 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-6-9 \
"M(0,3:00,12:00)\
-T(0,3:00,12:00)\
-W(0,3:00,12:00)\
-R(0,3:00,12:00)\
-F(0,3:00,12:00)\
-S(0,3:00,12:00)\
-U(0,3:00,12:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-6-11 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-7-4 \
"M(0,3:00,12:00)\
-T(0,3:00,12:00)\
-W(0,3:00,12:00)\
-R(0,3:00,12:00)\
-F(0,3:00,12:00)\
-S(0,3:00,12:00)\
-U(0,3:00,12:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-8-7 \
"M(0,3:00,12:00)\
-T(0,3:00,12:00)\
-W(0,3:00,12:00)\
-R(0,3:00,12:00)\
-F(0,3:00,12:00)\
-S(0,3:00,12:00)\
-U(0,3:00,12:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-8-15 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-8-21 \
"M(1,6:00,21:00)\
-T(1,6:00,21:00)\
-W(1,6:00,21:00)\
-R(1,6:00,21:00)\
-F(1,6:00,21:00)\
-S(1,6:00,21:00)\
-U(1,6:00,21:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-11-8 \
"M(0,9:00,18:00)\
-T(0,9:00,18:00)\
-W(0,9:00,18:00)\
-R(0,9:00,18:00)\
-F(0,9:00,18:00)\
-S(0,9:00,18:00)\
-U(0,9:00,18:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-11-14 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-11-19 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-12-5 \
"M(0,9:00,18:00)\
-T(0,9:00,18:00)\
-W(0,9:00,18:00)\
-R(0,9:00,18:00)\
-F(0,9:00,18:00)\
-S(0,9:00,18:00)\
-U(0,9:00,18:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-12-18 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-13-15 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-14-8 \
"M(0,9:00,18:00)\
-T(0,9:00,18:00)\
-W(0,9:00,18:00)\
-R(0,9:00,18:00)\
-F(0,9:00,18:00)\
-S(0,9:00,18:00)\
-U(0,9:00,18:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 ubuntu-15-10 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-15-17 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-16-6 \
"M(0,9:00,18:00)\
-T(0,9:00,18:00)\
-W(0,9:00,18:00)\
-R(0,9:00,18:00)\
-F(0,9:00,18:00)\
-S(0,9:00,18:00)\
-U(0,9:00,18:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-16-14 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-16-20 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-17-2 \
"M(0,9:00,18:00)\
-T(0,9:00,18:00)\
-W(0,9:00,18:00)\
-R(0,9:00,18:00)\
-F(0,9:00,18:00)\
-S(0,9:00,18:00)\
-U(0,9:00,18:00)"
$SCRIPT_DIR/generate_timeseries_insert.sh 30 1 alpine-19-10 \
"M(0,15:00)\
-T(0,15:00)\
-W(0,15:00)\
-R(0,15:00)\
-F(0,15:00)\
-S(0,15:00)\
-U(0,15:00)"