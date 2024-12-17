#!/bin/<distr_shell>

# Lock file
# lockfile="/var/lock/container_info.lock"

# Acquire lock
# exec 200>$lockfile
# flock -n 200 -w 0.5 || { echo "Failed to acquire lock."; exit 1; }

# awk -v key="Status" -v status="standby" -F", " '{if ($1 == key) $2 = status; print $1 ", " $2}' /usr/share/ils/conf/container_info.csv > tmpfile && mv tmpfile /usr/share/ils/conf/container_info.csv
sed -i 's/^Status, [^,]*/Status, standby/' /usr/share/ils/conf/container_info.csv

# Release lock
# flock -u 200