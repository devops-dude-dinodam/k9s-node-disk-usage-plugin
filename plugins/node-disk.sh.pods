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

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Color logic
if (( $(echo "$used_pct >= 90" | bc -l) )); then
  COLOR=$RED
elif (( $(echo "$used_pct >= 75" | bc -l) )); then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

# Bar
bar_width=20
blocks_used=$(awk -v pct="$used_pct" -v w="$bar_width" 'BEGIN { printf "%d", (pct/100)*w }')
blocks_free=$((bar_width - blocks_used))
used_bar=$(printf '█%.0s' $(seq 1 $blocks_used))
free_bar=$(printf '░%.0s' $(seq 1 $blocks_free))
bar="[$used_bar$free_bar]"

echo -e "Disk Usage for Node: $node\n"
echo -e "  Capacity : $cap_gb GB"
echo -e "  Used     : $used_gb GB ${COLOR}(${used_pct}%)${NC}"
echo -e "  Available: $avail_gb GB"
echo -e "  Usage    : ${COLOR}${bar}${NC}\n"

# 🔍 Top disk-using pods (best-effort)
echo -e "Top Pods by Disk Usage:\n"


kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$node" \
  --no-headers | awk '{print $1, $2}' | while read namespace pod; do
   usage=$(kubectl exec -n "$namespace" "$pod" -- sh -c 'du -s / 2>/dev/null || true' 2>/dev/null | awk '{print $1}')
    if [[ -n "$usage" ]]; then
      echo "$usage $namespace/$pod"
    fi
  done | sort -rn | head -5 | awk '{printf "  %-40s %6.2f MB\n", $2, $1/1024}'
