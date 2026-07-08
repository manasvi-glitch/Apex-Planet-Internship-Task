# Cybersecurity Basics — Study Notes

---

## 1. The CIA Triad

The CIA Triad is the foundational model for information security. Every security control or policy generally serves one (or more) of these three goals.

### Confidentiality
- Ensures information is accessible **only to authorized individuals**.
- Prevents unauthorized disclosure of sensitive data.
- **Mechanisms:** Encryption, access control lists (ACLs), authentication, data classification, VPNs.
- **Example breach:** A hacker steals a database of customer passwords.

### Integrity
- Ensures data is **accurate, complete, and unaltered** except by authorized action.
- Protects against unauthorized modification, whether malicious or accidental.
- **Mechanisms:** Hashing (SHA-256), checksums, digital signatures, version control, audit logs.
- **Example breach:** An attacker modifies a bank transaction amount in transit.

### Availability
- Ensures systems and data are **accessible when needed** by authorized users.
- Protects against downtime, outages, and denial-of-service conditions.
- **Mechanisms:** Redundancy, backups, load balancing, failover systems, DDoS protection.
- **Example breach:** A DDoS attack takes a website offline.

> **Memory tip:** CIA = "Confidentiality (secret), Integrity (correct), Availability (accessible)"

---

## 2. Common Threat Types

| Threat | Description | Key Defense |
|---|---|---|
| **Phishing** | Fraudulent emails/messages tricking users into revealing credentials or clicking malicious links. | Email filtering, user awareness training, MFA |
| **Malware** | Malicious software (viruses, worms, trojans, spyware) designed to damage or exploit systems. | Antivirus/EDR, patching, safe downloads |
| **DDoS (Distributed Denial of Service)** | Overwhelms a system with traffic from multiple sources, making it unavailable. | Rate limiting, CDNs, traffic scrubbing services |
| **SQL Injection** | Attacker inserts malicious SQL code into input fields to manipulate a database. | Input validation, parameterized queries/prepared statements |
| **Brute Force** | Repeatedly guessing passwords/keys until the correct one is found. | Account lockouts, strong passwords, MFA, rate limiting |
| **Ransomware** | Malware that encrypts victim's data and demands payment for the decryption key. | Regular backups, endpoint protection, patching, user training |

### Details Worth Remembering
- **Phishing** has variants: *Spear phishing* (targeted at a specific person), *Whaling* (targets executives), *Smishing* (via SMS), *Vishing* (via voice call).
- **Malware** types include: Virus (attaches to files), Worm (self-replicating, spreads without user action), Trojan (disguised as legitimate software), Spyware (covertly collects data).
- **DDoS** differs from DoS in that it uses **multiple** compromised systems (a botnet), making it harder to block.
- **SQL Injection** is part of the OWASP Top 10 web application risks.
- **Ransomware** notable examples: WannaCry, LockBit, Ryuk.

---

## 3. Attack Vectors

An **attack vector** is the path or method a threat actor uses to gain unauthorized access.

### Social Engineering
- Manipulating people (not systems) into breaking security procedures.
- Exploits human trust, urgency, fear, or curiosity rather than technical flaws.
- **Common techniques:** Pretexting (fake scenario), baiting (leaving infected USB drives), tailgating (following someone into a secure area), phishing (see above).
- **Defense:** Security awareness training, verification procedures, a strong "trust but verify" culture.

### Wireless Attacks
- Target Wi-Fi and other wireless networks/protocols.
- **Common techniques:**
  - **Evil Twin** — a rogue access point mimicking a legitimate network.
  - **Wardriving** — scanning for vulnerable wireless networks while moving (e.g., by car).
  - **Packet sniffing** — intercepting unencrypted wireless traffic.
  - **WPA/WEP cracking** — exploiting weak wireless encryption.
- **Defense:** Strong WPA3 encryption, hidden/segmented SSIDs, VPN use on public Wi-Fi, disabling unused wireless services.

### Insider Threats
- Risks originating from within the organization — employees, contractors, or partners.
- **Types:**
  - **Malicious insider** — intentionally causes harm (e.g., disgruntled employee).
  - **Negligent insider** — causes harm accidentally (e.g., misconfigured server, lost laptop).
  - **Compromised insider** — legitimate credentials are stolen/misused by an external attacker.
- **Defense:** Principle of least privilege, monitoring/logging, offboarding procedures, separation of duties.

---

## 4. Quick Summary Table

| Concept | Category | Core Idea |
|---|---|---|
| CIA Triad | Foundational model | Confidentiality, Integrity, Availability |
| Phishing, Malware, DDoS, SQL Injection, Brute Force, Ransomware | Threats | *What* can attack a system |
| Social Engineering, Wireless Attacks, Insider Threats | Attack Vectors | *How* attackers gain access |

