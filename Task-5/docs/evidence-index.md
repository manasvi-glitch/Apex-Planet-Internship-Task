# Evidence Index

This document maps the main evidence collected during Task 5 to the report sections.

| Evidence | Purpose |
|---|---|
| `task5_exposed_services.txt` | Initial service exposure |
| `task5_full_scan.txt` | Broad Nmap scan evidence |
| `task5_vulnerability_scan.txt` | Vulnerability-script results |
| `task5_rmi_validation.txt` | RMI vulnerability validation |
| `task5_webdav_options.txt` | WebDAV HTTP method evidence |
| `task5_webdav_listing.xml` | PROPFIND/WebDAV listing evidence |
| `task5_webdav_put.txt` | HTTP PUT evidence |
| `task5_webdav_verify.txt` | Successful retrieval of test file |
| `task5_webdav_delete.txt` | HTTP DELETE evidence |
| `evidence/incident-response/webdav_attack.txt` | Incident-response PUT evidence |
| `evidence/incident-response/webdav_eradication.txt` | Incident-response DELETE evidence |
| `webdav_incident_log.txt` | Apache access-log evidence |

## Evidence Principle

Every major finding should answer three questions:

1. **What was observed?**
2. **How was it validated?**
3. **What does the evidence prove?**

Avoid presenting a scanner label alone as proof of successful exploitation.
