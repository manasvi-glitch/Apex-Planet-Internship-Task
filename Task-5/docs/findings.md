# Findings and Mitigations

## F-01 — vsFTPd 2.3.4 Backdoor

**Severity:** Critical

**Service:** FTP / TCP 21

### Evidence

The FTP banner identified `vsFTPd 2.3.4`. The Metasploit validation module also reported that the target appeared vulnerable and that the backdoor condition was present.

The validation attempt did not produce a session.

### Risk

A vulnerable vsFTPd 2.3.4 deployment can expose the system to unauthorized access.

### Mitigation

- Remove or upgrade the vulnerable FTP implementation.
- Restrict FTP access using firewall/network controls.
- Prefer secure file-transfer mechanisms where appropriate.
- Monitor authentication and FTP service logs.

---

## F-02 — Java RMI Remote Class Loading

**Severity:** Critical/High

**Service:** Java RMI registry / TCP 1099

### Evidence

Nmap identified GNU Classpath `grmiregistry` on TCP/1099. The `rmi-vuln-classloader` script reported the configuration as vulnerable because remote classes could be loaded from URLs.

### Risk

An unsafe RMI configuration can permit remote code execution depending on the surrounding Java application and security configuration.

### Mitigation

- Disable RMI if it is not required.
- Restrict TCP/1099 to trusted hosts.
- Disable remote class loading.
- Patch and modernize the Java runtime/application.
- Monitor RMI connections.

---

## F-03 — WebDAV Write/Delete Capability

**Severity:** High

**Service:** HTTP / TCP 80, `/dav/`

### Evidence

WebDAV OPTIONS/PROPFIND responses confirmed DAV functionality. A harmless file was uploaded with HTTP PUT and returned `201 Created`. It was subsequently retrieved successfully, deleted with HTTP DELETE returning `204 No Content`, and then requested again, returning `404 Not Found`.

### Risk

Unauthenticated or insufficiently restricted write/delete access can allow unauthorized modification of web-accessible resources.

### Mitigation

- Disable WebDAV if it is not required.
- Restrict PUT/DELETE methods.
- Require authentication and authorization.
- Restrict WebDAV to trusted networks.
- Monitor WebDAV activity in server logs.

---

## F-04 — Legacy Apache/PHP Exposure

**Severity:** High/Medium

### Evidence

The HTTP service disclosed Apache `2.2.8` and PHP `5.2.4`. The target also exposed several web resources and administrative/testing functionality.

### Mitigation

- Upgrade unsupported software.
- Remove unnecessary test/admin resources.
- Restrict administrative interfaces.
- Disable unnecessary HTTP methods such as TRACE.
- Reduce server information disclosure.

---

## F-05 — Legacy Cryptographic/Service Configuration

**Severity:** High

### Evidence

The vulnerability scan identified legacy protocol/cryptographic weaknesses among the target's exposed services.

### Mitigation

- Disable obsolete protocols.
- Require modern TLS configurations.
- Remove unnecessary services.
- Apply host firewall rules and network segmentation.
