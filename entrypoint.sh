#!/bin/bash
set -e  # Aborts the script on error

log_file="/var/log/entrypoint_sh_logs.log"
list_of_daemons=($(vtysh -c "show daemon" | awk '/^ *[a-zA-Z0-9_-]+/ {print $1}'))

echo "=======================" | tee -a "$log_file"
echo "Restarting FRR to enable DAEMONS..." | tee -a "$log_file"
echo "=======================" | tee -a "$log_file"

# Restart FRR
/usr/lib/frr/frrinit.sh restart
restart_status=$?

# Check the restart status
if [ $restart_status -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FRR successfully restarted" | tee -a "$log_file"
    for daemon in "${list_of_daemons[@]}"; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Enabled daemon(s): $daemon" | tee -a "$log_file"
    done
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FRR failed to restart" | tee -a "$log_file" # Logs can be seen from docker logs command
    exit 1  # Aborts the script on error
fi

# Make the container active and track the logs (in real time)
tail -f "$log_file"