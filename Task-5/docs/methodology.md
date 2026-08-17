# Methodology

## 1. Scope

The assessment was limited to the intentionally vulnerable Metasploitable 2 virtual machine at `192.168.47.133`.

The Kali Linux VM at `192.168.47.132` was used as the assessment workstation.

## 2. Assessment Phases

### Phase 1 — Reconnaissance

Confirm that the target is reachable and identify the target IP and basic network context.

### Phase 2 — Service Enumeration

Use Nmap to identify open TCP services and collect service/version information.

The objective is to understand the target's attack surface before selecting individual findings for validation.

### Phase 3 — Vulnerability Identification

Use targeted Nmap vulnerability scripts and the available scan results to identify high-risk services and configurations.

Important results included:

- vsFTPd 2.3.4
- Java RMI registry on TCP/1099
- WebDAV functionality
- Legacy Apache/PHP components
- Additional exposed legacy services

### Phase 4 — Controlled Validation

Selected findings were manually validated.

For vsFTPd, Metasploit was used to test the known backdoor module. The module reported the vulnerable banner/backdoor condition, but **no session was created**. This distinction is important: vulnerability detection and successful exploitation are not the same result.

For RMI, the Nmap `rmi-vuln-classloader` script reported the service as vulnerable to remote class loading.

For WebDAV, cURL was used to demonstrate allowed HTTP methods and a harmless write/delete cycle.

### Phase 5 — Evidence Collection

Evidence was saved as text files and screenshots. Examples include:

- Nmap service/version results
- Nmap vulnerability results
- RMI validation output
- WebDAV OPTIONS/PROPFIND responses
- WebDAV PUT/GET/DELETE responses
- Apache access-log entries

### Phase 6 — Incident Response Simulation

A harmless file was created as a simulated unauthorized artifact.

The response process followed:

1. **Detection** — identify the WebDAV PUT request in Apache logs.
2. **Analysis** — correlate source IP, timestamp, URI and HTTP status.
3. **Eradication** — remove the artifact with HTTP DELETE.
4. **Verification** — request the resource again and confirm HTTP 404.
5. **Documentation** — preserve evidence and record the sequence.

### Phase 7 — Reporting

Findings were categorized by risk and accompanied by practical mitigation recommendations.

## 3. Risk Interpretation

Risk was considered using:

- Exposure of the service
- Potential impact
- Ease of abuse
- Whether the finding could lead to code execution or unauthorized modification
- Whether the behavior was manually validated

Because this is a deliberately vulnerable training VM, the findings are expected and should not be interpreted as evidence about a production system.

## 4. Limitations

- The assessment was restricted to the laboratory target.
- Not every scanner finding was manually exploited.
- The vsFTPd test did not produce a session.
- The WebDAV incident used a harmless test file.
- Scanner findings should be independently validated before being treated as confirmed production vulnerabilities.
