#!/usr/bin/env bash

# Pre-apply, on schedule
get_update_status() { 
value=$(cat SG_UPDATE_DETECTED 2>/dev/null)
if [ "$value" = "True" ]; then
    echo "Update detected. Proceeding with deployment."
    exit 0
else
    echo "No update needed. Exiting."
    exit 1
fi
}
get_update_status


# Post-apply step
set_update_status() { 
    echo "Updating status of SG_UPDATE_DETECTED..."
    echo "False" > SG_UPDATE_DETECTED
}
set_update_status
