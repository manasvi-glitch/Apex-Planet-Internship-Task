# Attack Scenarios & Mitigation Notes
### Task 3 — Web Application Security Testing (DVWA)

**Target:** DVWA (Damn Vulnerable Web Application) — `http://localhost/dvwa/`
**Environment:** Kali Linux, Apache 2.4.68, PHP/MySQL, Burp Suite Community Edition
**Scope:** Local, isolated lab environment — authorized testing only

This document walks through each vulnerability class tested during Task 3 as an **attacker-perspective scenario**, followed by the **impact** and the **mitigation** applied or recommended. It's meant to sit in the GitHub repo alongside the screenshots and the full report as a quick-reference for reviewers.

---

## 1. SQL Injection

**Attack Scenario**
An attacker browses to DVWA's SQL Injection module and, instead of supplying a valid user ID, submits a crafted string containing SQL metacharacters (e.g. `' OR '1'='1`). Because the application concatenates this input directly into the backend SQL query rather than treating it as data, the injected syntax changes the query's logic. The database returns rows the attacker was never authorized to see — potentially every user record in the table instead of just one.

**Why it works:** the query is built by string concatenation, so user input is indistinguishable from SQL code once it reaches the database engine.

**Impact**
- Unauthorized retrieval of database records (usernames, password hashes)
- Authentication bypass
- Enumeration of database structure/records
- Potential data modification or deletion, depending on account privileges

**Mitigation**
- Use **prepared statements / parameterized queries** everywhere — never concatenate user input into SQL
- Apply server-side input validation as defense-in-depth (not a substitute for parameterization)
- Run the application's DB account under the **principle of least privilege**
- Suppress detailed database error messages in production (they leak schema info)

---

## 2. Cross-Site Scripting (XSS) — Reflected & Stored

**Attack Scenario (Reflected)**
An attacker crafts a URL where a query parameter contains a JavaScript payload (e.g. `<script>alert(document.cookie)</script>`). They send this link to a victim — via email, chat, or a malicious ad. When the victim clicks it, the vulnerable page reflects the parameter back into the HTML response without encoding it, and the browser executes it as if it were part of the trusted site.

**Attack Scenario (Stored)**
An attacker submits a malicious script through a form field that gets saved server-side (e.g. a comment or message field). The payload is now persisted. Every subsequent user who views that page — not just the original attacker — has the script run in their browser, in the security context of the trusted site. This is more dangerous than reflected XSS because it needs no victim interaction with a crafted link.

**Impact**
- Arbitrary JavaScript execution in a victim's browser
- Session/cookie theft, enabling session hijacking
- Defacement or manipulation of page content
- Actions performed on behalf of the victim (CSRF-like effects)
- Phishing delivered from a trusted-looking domain

**Mitigation**
- **Context-aware output encoding** for anything reflected into HTML, attributes, JS, or URLs
- Input validation as a secondary layer
- Avoid unsafe HTML-rendering sinks (`innerHTML`, `eval`, etc.)
- Implement a strict **Content-Security-Policy (CSP)** to block inline script execution
- Set cookies with `HttpOnly` and `SameSite` attributes so stolen scripts can't read them

---

## 3. Cross-Site Request Forgery (CSRF)

**Attack Scenario**
An attacker hosts a malicious page containing a hidden auto-submitting form pointed at DVWA's password-change endpoint. If a logged-in victim visits that page, their browser automatically sends the forged request — including their valid session cookie — to DVWA. If the application trusts any authenticated request regardless of origin, the victim's password gets silently changed without their knowledge.

**What was observed:** DVWA rejected the forged/replayed request with *"CSRF token is incorrect"* — confirming the application validates an unpredictable per-request token before accepting the state-changing action.

**Impact (if unmitigated)**
- Unauthorized state-changing actions performed as the victim (password change, fund transfer, settings change, etc.)
- Full account takeover if combined with a password-change endpoint

**Mitigation (confirmed effective here)**
- Unpredictable, per-session (or per-request) **CSRF tokens**, validated server-side on every state-changing request
- `SameSite` cookie attributes to prevent cross-site cookie transmission
- Never perform state changes via `GET` requests
- Origin/Referer header validation as a supplementary check

---

## 4. Local File Inclusion (LFI)

**Attack Scenario**
The File Inclusion module takes a `page` parameter and uses it to determine which file to load and display. An attacker replaces the expected value with a path to a sensitive local file (e.g. the Linux password file location) and traversal sequences if needed. Because the application does not restrict which paths are permitted, it happily reads and returns the file contents — the attacker retrieves system information they were never meant to see.

**What was observed:** the contents of `/etc/passwd` were rendered directly in the browser, confirming the parameter was passed to a file-read operation without an allowlist or path restriction.

**Impact**
- Disclosure of sensitive local files and system information
- Discovery of usernames and configuration data
- Exposure of credentials/secrets stored in accessible files
- Can be chained with other bugs (e.g. log poisoning) for further escalation

**Mitigation**
- Never map user input directly to a filesystem path
- Use an **allowlist** of permitted files/identifiers, resolved server-side (e.g. `page=1` → internal lookup table, not a raw filename)
- Canonicalize and validate any path before use; reject traversal sequences
- Restrict filesystem permissions for the web server process
- Disable file-inclusion functionality entirely if it isn't needed

---

## 5. Remote File Inclusion (RFI)

**Attack Scenario**
An attacker attempts to point the same `page` parameter at a remote URL they control, hosting malicious PHP code. If the PHP engine is configured to allow remote inclusion, the server would fetch and **execute** that attacker-controlled code — a direct path to full remote code execution.

**What was observed:** the request returned `ERROR: File not found!`. Inspection of `php.ini` confirmed `allow_url_include = Off` (while `allow_url_fopen = On`), so the server refused to treat the remote resource as includable PHP. RFI was tested but could not be demonstrated — this is the *secure* outcome, not a testing failure.

**Impact (if `allow_url_include` were enabled)**
- Remote code execution on the server
- Full server compromise
- Pivot point into internal network/infrastructure

**Mitigation (confirmed effective here)**
- Keep `allow_url_include = Off` in production PHP configuration — this alone neutralizes classic RFI
- Never build include/require paths from user input, even with RFI disabled (LFI risk remains)
- Allowlist permitted resources
- Strict server-side validation of any file-related parameter

---

## 6. HTTP Request Interception & Modification (Burp Suite Proxy)

**Attack Scenario**
An attacker positioned as a man-in-the-middle (or simply using an intercepting proxy against their own traffic, as done here) captures a login request before it reaches the server, then modifies parameters — such as the username — before forwarding it. This demonstrates that **any value sent from the client cannot be trusted**, because nothing prevents an attacker from altering it in transit before the server ever sees it.

**What was observed:** the modified request was successfully forwarded, and DVWA correctly rejected it with a login failure — confirming server-side validation of credentials rather than reliance on client-side assumptions.

**Impact (if server trusted client-side data)**
- Parameter tampering leading to privilege escalation, price manipulation, IDOR, or auth bypass
- Bypass of client-side-only validation or business logic

**Mitigation**
- Treat **all client input as untrusted** — validate and authorize every request server-side
- Never rely on hidden form fields, JS validation, or client state for security decisions
- Use HTTPS to make interception harder (doesn't prevent it if the client controls the proxy, but stops passive network eavesdropping)

---

## 7. Automated Fuzzing (Burp Intruder)

**Attack Scenario**
An attacker captures a login request and sends it to Burp Intruder, marking the password field as the attack position. A wordlist of common passwords (`admin`, `1234`, `test123`, `password`, `letmein`, `qwerty`, etc.) is loaded and fired automatically against the login endpoint, with responses compared by length/content/status code to spot the one that succeeds. This is the mechanics of an **online brute-force / credential-stuffing attack**.

**What was observed:** the successful attempt returned *"Welcome to the password protected area admin"* while failures returned *"Username and/or password incorrect"* — a clear, automatable oracle for distinguishing success from failure.

**Impact**
- Account compromise via weak/guessable credentials
- At scale, credential stuffing across many accounts using breached password lists

**Mitigation**
- Enforce **strong password policies**
- **Account lockout** or progressive delays after repeated failures
- **Rate limiting** on authentication endpoints
- **Multi-factor authentication (MFA)**
- CAPTCHA on repeated failed attempts
- Monitoring/alerting on authentication failure spikes
- Avoid response messages that make success/failure trivially distinguishable

---

## 8. Missing / Misconfigured HTTP Security Headers

**Attack Scenario**
A reference site was scanned with securityheaders.com and received an **F grade**, missing `Strict-Transport-Security`, `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, and `Permissions-Policy`. Without these, an attacker could, for example: frame the site in an invisible iframe for clickjacking (no `X-Frame-Options`), get the browser to MIME-sniff a malicious upload as executable content (no `X-Content-Type-Options`), or rely on the absence of CSP to make injected scripts (from an XSS bug) execute freely.

**Mitigation implemented (Apache + DVWA)**
Configured and verified via `curl -I`:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: SAMEORIGIN`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: geolocation=(), microphone=(), camera=()`
- `Content-Security-Policy: default-src 'self'; ...`

| Header | Purpose |
|---|---|
| Content-Security-Policy | Restricts allowed content sources; major XSS mitigation |
| X-Frame-Options | Prevents clickjacking via unauthorized framing |
| X-Content-Type-Options | Blocks MIME-type sniffing |
| Referrer-Policy | Limits referrer data leaked to other origins |
| Permissions-Policy | Restricts access to browser features (camera, mic, geolocation) |
| Strict-Transport-Security | Forces HTTPS after first secure connection |

---

## Summary Table

| Vulnerability | Demonstrated? | Root Cause | Key Mitigation |
|---|---|---|---|
| SQL Injection | Yes | Unparameterized queries | Prepared statements |
| XSS (Reflected & Stored) | Yes | Missing output encoding | Output encoding + CSP |
| CSRF | Blocked (token validated) | N/A — protection worked | Anti-CSRF tokens |
| LFI | Yes | Unvalidated file path param | Allowlist file paths |
| RFI | Blocked (`allow_url_include=Off`) | N/A — config already secure | Keep remote inclusion disabled |
| Auth brute-force (Intruder) | Demonstrated | No rate limiting on login | Lockout, rate limiting, MFA |
| Missing security headers | Identified (F grade) | Headers not configured | Apache header configuration |

---

## Notes for the Repo

- All testing was performed against a locally hosted, intentionally vulnerable application (DVWA) in an isolated lab — no external systems were targeted.
- This file is a companion to the full **Web Application Security Testing Report**, which contains the detailed testing procedures, environment configuration, and step-by-step observations.
