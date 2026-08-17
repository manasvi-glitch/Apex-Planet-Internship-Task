# Task 5 — Capstone Project & Incident Response

A controlled cybersecurity assessment of an intentionally vulnerable **Metasploitable 2** virtual machine from a **Kali Linux** assessment VM.

> **Lab-only project:** All testing described here was performed against the intentionally vulnerable training VM on an isolated laboratory network. Do not use these procedures against systems without explicit authorization.

## Environment

| System | IP |
|---|---|
| Kali Linux | `192.168.47.132` |
| Metasploitable 2 | `192.168.47.133` |
| Network | `192.168.47.0/24` |

## Objectives

1. Perform reconnaissance and service enumeration.
2. Identify significant vulnerabilities and insecure configurations.
3. Validate selected findings in a controlled manner.
4. Collect evidence and preserve outputs.
5. Simulate an incident involving WebDAV write access.
6. Detect the activity in server logs.
7. Remove the test artifact and verify remediation.
8. Document findings, risks, mitigations and lessons learned.

## Tools

- Nmap
- cURL
- Metasploit Framework
- Apache access logs on Metasploitable 2

## Key Findings

- **vsFTPd 2.3.4 backdoor condition** on TCP/21.
- **Java RMI remote class-loading vulnerability** on TCP/1099.
- **WebDAV write/delete capability** under `/dav/`.
- Legacy Apache/PHP and additional exposed services increasing attack surface.
- Legacy cryptographic/service configurations identified during scanning.

## Important Validation Note

The vsFTPd Metasploit validation **did not create an interactive session**. The repository therefore records it as a vulnerability-validation attempt rather than claiming successful exploitation.

## WebDAV Incident Simulation

A harmless file named `incident_test.txt` was:

1. Created through WebDAV using HTTP PUT.
2. Observed in the Apache access log.
3. Deleted using HTTP DELETE.
4. Requested again and confirmed absent with HTTP 404.

This provides a complete controlled incident-response sequence:

**Simulate → Detect → Eradicate → Verify**

## Repository Structure

```text
task5-github-repo/
├── README.md
├── docs/
│   ├── methodology.md
│   ├── findings.md
│   ├── incident-response.md
│   ├── presentation-notes.md
│   └── evidence-index.md
└── scripts/
    ├── 01_recon_and_enumeration.sh
    ├── 02_webdav_validation.sh
    ├── 03_incident_simulation.sh
    └── 04_incident_log_review.sh
```

## Disclaimer

This repository is educational material for an isolated cybersecurity laboratory. The author does not claim authorization to test any external systems.
