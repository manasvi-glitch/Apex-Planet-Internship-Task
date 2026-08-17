#!/usr/bin/env bash
# Task 5 — reconnaissance and service enumeration
# LAB ONLY: replace TARGET only with the authorized Metasploitable 2 lab IP.

set -euo pipefail

TARGET="${1:-192.168.47.133}"
OUT="${2:-task5_full_scan.txt}"

echo "[+] Target: $TARGET"
echo "[+] Saving full scan to: $OUT"

nmap -sV -sC -O "$TARGET" -oN "$OUT"

echo "[+] Enumeration complete."
