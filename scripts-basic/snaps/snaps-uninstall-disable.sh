#! /bin/sh

# Remove inactive snap applications

# List all snaps and filter for those not in use
snaps=$(snap list --all | grep disabled | awk '{print $1 ":" $3}')

echo snaps to check for inactivity:
echo "$snaps"
for snap in $snaps; do
   echo "Checking snap: $snap"
    # Check if snap process is running
    if ! pgrep -f "$snap" > /dev/null 2>&1; then
       snap_name=$(echo "$snap" | awk -F: '{print $1}')
       snap_revision=$(echo "$snap" | awk -F: '{print $2}')
       echo "sudo snap remove $snap_name --revision $snap_revision --purge"
       sudo snap remove $snap_name --revision $snap_revision --purge
    fi
done

echo "Cleanup complete"