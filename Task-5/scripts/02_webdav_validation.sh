#!/usr/bin/env bash
# Task 5 — controlled WebDAV validation
# LAB ONLY. Uses a harmless test file.

set -euo pipefail

TARGET="${1:-192.168.47.133}"
BASE="http://${TARGET}/dav"
FILE="dav_test.txt"

printf 'Task 5 WebDAV write test\n' > "$FILE"

echo "[1] OPTIONS"
curl -i -X OPTIONS "$BASE/"

echo "[2] PROPFIND"
curl -i -X PROPFIND -H "Depth: 1" "$BASE/"

echo "[3] PUT harmless test file"
curl -i -T "$FILE" "$BASE/$FILE"

echo "[4] GET verification"
curl -i "$BASE/$FILE"

echo "[5] DELETE"
curl -i -X DELETE "$BASE/$FILE"

echo "[6] GET after deletion (expected: 404)"
curl -i "$BASE/$FILE"

rm -f "$FILE"
