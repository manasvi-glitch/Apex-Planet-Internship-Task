# Networking Basics — Study Notes

---

## 1. The OSI Model — Layers & Functions

The OSI (Open Systems Interconnection) Model is a 7-layer conceptual framework describing how data moves through a network. Data flows **down** the stack when sending, and **up** the stack when receiving.

| Layer # | Layer Name | Function | Examples/Protocols |
|---|---|---|---|
| 7 | **Application** | Interface for end-user services and applications | HTTP, FTP, SMTP, DNS |
| 6 | **Presentation** | Data translation, encryption, compression | SSL/TLS, JPEG, ASCII |
| 5 | **Session** | Establishes, manages, and terminates connections/sessions | NetBIOS, RPC |
| 4 | **Transport** | Reliable end-to-end delivery, segmentation, flow control | TCP, UDP |
| 3 | **Network** | Logical addressing and routing between networks | IP, ICMP, routers |
| 2 | **Data Link** | Physical addressing (MAC), frames, error detection | Ethernet, switches, MAC address |
| 1 | **Physical** | Raw bit transmission over physical medium | Cables, hubs, radio signals |

> **Memory tip (top to bottom):** "**A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing"

### Key Points
- Each layer only communicates with the layer directly above/below it (and its peer layer on the receiving device).
- **Encapsulation:** as data moves down the stack, each layer adds its own header (and sometimes trailer) — this bundle is passed to the next layer.
- **Decapsulation:** the reverse happens on the receiving end.
- Layers 1–4 are often called the "lower layers" (hardware/transport focused); Layers 5–7 are the "upper layers" (software/application focused).

---

## 2. TCP/IP Protocol Suite

The TCP/IP model is the practical, 4-layer framework the modern internet actually runs on. It maps loosely onto the OSI model.

| TCP/IP Layer | Roughly Maps to OSI Layers | Key Protocols |
|---|---|---|
| **Application** | Application, Presentation, Session (5–7) | HTTP, HTTPS, FTP, DNS, SMTP |
| **Transport** | Transport (4) | TCP, UDP |
| **Internet** | Network (3) | IP, ICMP, ARP |
| **Network Access (Link)** | Data Link, Physical (1–2) | Ethernet, Wi-Fi |

### TCP vs UDP

| Feature | TCP | UDP |
|---|---|---|
| Connection | Connection-oriented (3-way handshake) | Connectionless |
| Reliability | Reliable — guarantees delivery & order | Unreliable — "best effort" |
| Speed | Slower (overhead from acknowledgments) | Faster (minimal overhead) |
| Use Cases | Web browsing, email, file transfer | Video streaming, VoIP, DNS queries, gaming |

### The TCP 3-Way Handshake
1. **SYN** — Client sends a synchronize request to the server.
2. **SYN-ACK** — Server acknowledges and sends its own synchronize request back.
3. **ACK** — Client acknowledges; connection is established.

### Key Protocols to Know
- **IP (Internet Protocol):** handles addressing and routing of packets.
- **ICMP:** used for diagnostics (e.g., `ping`, `traceroute`).
- **ARP (Address Resolution Protocol):** maps IP addresses to MAC addresses on a local network.

---

## 3. DNS & HTTP/HTTPS Deep Dive

### DNS (Domain Name System)
- Translates human-readable domain names (e.g., `example.com`) into IP addresses.
- Often called the "phonebook of the internet."

**DNS Resolution Process:**
1. Browser checks local cache.
2. Query sent to a **recursive resolver** (usually your ISP or a public resolver like 8.8.8.8).
3. Resolver queries a **root server** → directs to the correct **TLD server** (e.g., `.com`).
4. TLD server directs to the **authoritative name server** for the domain.
5. Authoritative server returns the IP address.
6. Browser connects to that IP.

**Common DNS Record Types:**
| Record | Purpose |
|---|---|
| A | Maps domain to an IPv4 address |
| AAAA | Maps domain to an IPv6 address |
| CNAME | Alias — points one domain to another domain |
| MX | Specifies mail servers for the domain |
| TXT | Holds arbitrary text (often used for verification, SPF records) |
| NS | Specifies authoritative name servers |

### HTTP (HyperText Transfer Protocol)
- Application-layer protocol for transferring web content.
- **Stateless:** each request is independent (state is maintained via cookies/sessions).
- **Common Methods:** `GET` (retrieve data), `POST` (submit data), `PUT` (update), `DELETE` (remove).
- **Common Status Codes:**
  - `200 OK` — success
  - `301/302` — redirect
  - `404 Not Found` — resource missing
  - `500 Internal Server Error` — server-side failure

### HTTPS (HTTP Secure)
- HTTP layered over **TLS/SSL encryption**.
- Provides:
  - **Confidentiality** — data is encrypted in transit.
  - **Integrity** — data can't be tampered with undetected.
  - **Authentication** — verifies the server's identity via certificates.
- Uses **port 443** (vs HTTP's port 80).
- **TLS Handshake (simplified):** client and server agree on encryption method, exchange/verify certificates, generate session keys, then begin encrypted communication.

---

## 4. IP Addressing, Subnetting, and NAT

### IP Addressing
- **IPv4:** 32-bit address, written as 4 octets (e.g., `192.168.1.10`). ~4.3 billion possible addresses.
- **IPv6:** 128-bit address, written in hexadecimal (e.g., `2001:0db8::1`). Designed to solve IPv4 exhaustion.
- **Public vs Private IPs:**
  - Private ranges (not routable on the internet): `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`.
  - Public IPs are globally unique and routable.

### Subnetting
- Dividing a large network into smaller, manageable sub-networks ("subnets").
- Uses a **subnet mask** (e.g., `255.255.255.0` or `/24`) to separate the **network portion** from the **host portion** of an IP address.

**Example:**
- `192.168.1.0/24` → subnet mask `255.255.255.0`
- 24 bits for network, 8 bits for hosts → 256 addresses total, 254 usable (excluding network & broadcast addresses).

**Why subnet?**
- Improves security (isolating segments).
- Reduces broadcast traffic.
- Organizes networks logically (e.g., by department).

**CIDR Notation:** Shorthand for subnet masks — `/24` = `255.255.255.0`, `/16` = `255.255.0.0`, etc. The number indicates how many bits are the network portion.

### NAT (Network Address Translation)
- Translates private IP addresses to a public IP address (and vice versa) so internal devices can access the internet.
- Conserves the limited pool of public IPv4 addresses.

**Types of NAT:**
| Type | Description |
|---|---|
| **Static NAT** | One-to-one mapping between a private and public IP (permanent) |
| **Dynamic NAT** | Maps private IPs to a pool of public IPs (as needed) |
| **PAT (Port Address Translation)** | Many private IPs share **one** public IP, differentiated by port numbers — most common form (used in home routers) |

**Example:** Your home router has one public IP, but every device on your Wi-Fi (private IPs like `192.168.1.5`, `192.168.1.6`) shares it via PAT, distinguished by port numbers.

---

## 5. Quick Summary Table

| Concept | Core Idea |
|---|---|
| OSI Model | 7-layer conceptual framework for network communication |
| TCP/IP Suite | 4-layer practical model that powers the real internet |
| DNS | Translates domain names into IP addresses |
| HTTP/HTTPS | Protocols for transferring (and securing) web content |
| IP Addressing | Uniquely identifies devices on a network |
| Subnetting | Divides networks into smaller, manageable segments |
| NAT | Lets private IPs share public IP(s) to access the internet |

