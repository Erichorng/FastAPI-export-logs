#!/bin/bash

# Specify the output directory where you want to save the logs
base_directory="/export"
log_directory="logs"
output_directory="${base_directory}/${log_directory}"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# List all pods and their UIDs
pod_uids=$(find /var/log/pods -mindepth 1 -maxdepth 1 -type d)
echo $pod_uids
# Loop through each pod's directory
for pod_dir in $pod_uids; do
    pod_uid=$(basename "$pod_dir")
    pod_uid="${pod_uid%_*}"
    #pod_uid="${pod_uid%-*}"
    # Loop through each container in the pod
    container_dirs=$(find "$pod_dir" -mindepth 1 -maxdepth 1 -type d)
    for container_dir in $container_dirs; do
        container_name=$(basename "$container_dir")

        # Create a log file name based on the pod UID and container name
        log_file="$output_directory/${pod_uid}_${container_name}.log"

        # Use 'cat' to concatenate the stdout and stderr logs and save them to the log file
        cat "$container_dir"/0.log > "$log_file"

        echo "Collected logs for pod: $pod_uid, container: $container_name"
    done
done

# syslog
log_file="$output_directory/kern.log"
cat "/var/log/kern.log" > "$log_file"

# klog
log_file="$output_directory/sys.log"
cat "/var/log/syslog" > "$log_file"

echo "zipping..."
cd ${base_directory}
zip -r ${log_directory}.zip ${log_directory}
echo "Log collection complete."
