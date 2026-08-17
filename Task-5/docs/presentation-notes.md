# Task 5 Presentation Notes

## Suggested 12-Minute Structure

### 0:00–1:00 — Introduction

> "This capstone demonstrates a controlled security assessment and incident-response exercise against Metasploitable 2. Kali Linux was used as the assessment machine, and all activity was performed inside an isolated laboratory network."

Show:
- Lab topology
- Target IP
- Kali IP

### 1:00–2:00 — Objectives and Methodology

Explain:

- Reconnaissance
- Service enumeration
- Vulnerability identification
- Controlled validation
- Evidence collection
- Incident response

### 2:00–4:00 — Reconnaissance and Findings

Show Nmap results.

Mention that the target exposed a large number of legacy services.

Focus on:

- FTP / 21
- HTTP / 80
- RMI / 1099
- SMB and other legacy services

### 4:00–5:30 — vsFTPd Validation

Show the Metasploit validation output.

Important wording:

> "The target reported the vulnerable vsFTPd 2.3.4 condition, but the validation did not create an interactive session. I am therefore documenting this as a confirmed vulnerability condition and a failed session-establishment attempt, rather than claiming successful exploitation."

### 5:30–6:30 — RMI Validation

Show the Nmap RMI result.

Explain:

> "TCP 1099 was identified as a Java RMI registry, and the rmi-vuln-classloader check reported that remote class loading was enabled."

### 6:30–8:30 — WebDAV Validation

Show:

1. OPTIONS
2. PROPFIND
3. PUT
4. GET
5. DELETE
6. GET returning 404

Explain that the file was harmless and used only as a controlled test artifact.

### 8:30–10:30 — Incident Response

Show the Apache log.

Explain:

> "The simulated incident was detected by searching the Apache access log for the test filename. The log provided the source IP, timestamp, HTTP method and requested URI."

Then show deletion and 404 verification.

### 10:30–11:30 — Risk and Mitigation

Summarize the highest-priority recommendations:

- Upgrade/remove vulnerable vsFTPd.
- Disable/restrict RMI.
- Disable or authenticate WebDAV.
- Restrict HTTP methods.
- Remove legacy software.
- Reduce exposed services.
- Monitor server logs.

### 11:30–12:00 — Conclusion

> "The project demonstrated the full workflow from reconnaissance to vulnerability validation and incident response. The most important lesson was that technical findings need evidence and that incident response requires detection, eradication and post-remediation verification."

## Delivery Tips

- Do not claim a successful Metasploit session.
- Keep the focus on methodology and evidence.
- Explain what each screenshot proves.
- Avoid reading every scan result.
- Spend the most time on the WebDAV incident-response story because it provides a complete end-to-end demonstration.
