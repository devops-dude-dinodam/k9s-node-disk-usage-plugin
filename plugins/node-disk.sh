#!/bin/bash
set -euo pipefail

node="$1"
fs=$(kubectl get --raw /api/v1/nodes/${node}/proxy/stats/summary | jq '.node.fs')

available=$(echo "$fs" | jq '.availableBytes')
capacity=$(echo "$fs" | jq '.capacityBytes')
used=$(echo "$fs" | jq '.usedBytes')

avail_gb=$(awk "BEGIN {printf \"%.2f\", $available/1024/1024/1024}")
cap_gb=$(awk "BEGIN {printf \"%.2f\", $capacity/1024/1024/1024}")
used_gb=$(awk "BEGIN {printf \"%.2f\", $used/1024/1024/1024}")
used_pct=$(awk "BEGIN {printf \"%.2f\", ($used/$capacity)*100}")

# Determine color
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Reset

if (( $(echo "$used_pct >= 90" | bc -l) )); then
  COLOR=$RED
elif (( $(echo "$used_pct >= 75" | bc -l) )); then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

# Create usage bar (20 blocks)
bar_width=20
blocks_used=$(awk -v pct="$used_pct" -v w="$bar_width" 'BEGIN { printf "%d", (pct/100)*w }')
blocks_free=$((bar_width - blocks_used))

used_bar=$(printf '█%.0s' $(seq 1 $blocks_used))
free_bar=$(printf '░%.0s' $(seq 1 $blocks_free))
bar="[$used_bar$free_bar]"

# Final output
echo -e "Disk Usage for Node: ${node}\n"
echo -e "  Capacity : ${cap_gb} GB"
echo -e "  Used     : ${used_gb} GB ${COLOR}(${used_pct}%)${NC}"
echo -e "  Available: ${avail_gb} GB"
echo -e "  Usage    : $COLOR$bar${NC}"

