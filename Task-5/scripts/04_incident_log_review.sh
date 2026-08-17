#!/usr/bin/env bash
# Task 5 — local evidence review on the Metasploitable 2 lab VM.
# Run on the target VM where the Apache log is available.

set -euo pipefail

ARTIFACT="${1:-incident_test.txt}"
LOG="/var/log/apache2/access.log"
OUT="${2:-/tmp/webdav_incident_log.txt}"

echo "[+] Searching Apache access log for: $ARTIFACT"
sudo grep "$ARTIFACT" "$LOG" | tee "$OUT"

echo "[+] Evidence saved to: $OUT"
