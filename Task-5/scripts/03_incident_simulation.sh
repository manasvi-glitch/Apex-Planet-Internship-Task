#!/usr/bin/env bash
# Task 5 — WebDAV incident-response simulation
# LAB ONLY. The artifact is intentionally harmless.

set -euo pipefail

TARGET="${1:-192.168.47.133}"
ARTIFACT="incident_test.txt"
BASE="http://${TARGET}/dav"
OUTDIR="${2:-evidence/incident-response}"

mkdir -p "$OUTDIR"

printf 'INCIDENT RESPONSE TEST\n' > "$ARTIFACT"

echo "[+] Simulating unauthorized WebDAV file creation"
curl -i -T "$ARTIFACT" "$BASE/$ARTIFACT" \
  | tee "$OUTDIR/webdav_attack.txt"

echo "[+] The next phase is log review on the Metasploitable 2 VM."
echo "[+] Remove the test artifact after evidence collection."
