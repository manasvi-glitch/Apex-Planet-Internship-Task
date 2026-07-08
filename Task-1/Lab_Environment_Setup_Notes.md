# Lab Environment Setup — Study Notes

---

## 1. Install a Hypervisor (VirtualBox or VMware)

A hypervisor lets you run multiple virtual machines (VMs) on one physical computer — essential for building an isolated practice lab.

### Options

| Hypervisor | Notes |
|---|---|
| **VirtualBox** | Free, open-source, cross-platform (Windows/Mac/Linux). Great for beginners. |
| **VMware Workstation Player/Pro** | Free (Player) or paid (Pro). Generally better performance and USB/graphics support. Mac users can use **VMware Fusion**. |

### General Setup Steps
1. Download the installer from the official site (virtualbox.org or vmware.com).
2. Ensure **virtualization is enabled** in your BIOS/UEFI (Intel VT-x or AMD-V).
3. Install the hypervisor with default settings.
4. (VirtualBox) Install the **Extension Pack** for USB 2.0/3.0 support and other features.
5. Verify installation by opening the app and creating a blank test VM.

> **Tip:** Allocate at least 8–16 GB RAM and a multi-core CPU on your host machine if you plan to run multiple VMs simultaneously.

---

## 2. Install Kali Linux (Attacker Machine)

**Kali Linux** is a Debian-based distribution pre-loaded with penetration testing and security tools (Nmap, Metasploit, Burp Suite, Wireshark, etc.).

### Setup Steps
1. Download the **Kali Linux VM image** (pre-built `.ova`/`.vmdk` file) from the official site — this is faster than installing from an ISO.
   - Official source: `kali.org/get-kali/#kali-virtual-machines`
2. Import the image into VirtualBox/VMware:
   - VirtualBox: **File → Import Appliance**
   - VMware: **File → Open**, then select the `.vmx` file
3. Allocate resources: minimum **2 CPU cores, 4 GB RAM, 20+ GB disk**.
4. Boot the VM and log in with default credentials (`kali` / `kali` on recent images — change this immediately).
5. Update the system:
   ```
   sudo apt update && sudo apt full-upgrade -y
   ```
6. Confirm key tools are present: `nmap -v`, `msfconsole`, `burpsuite`.

> Kali is meant to be the **attacker** machine — it should never be your daily-use OS.

---

## 3. Install Target Machines (Metasploitable2 / DVWA)

Target machines are **intentionally vulnerable** systems used to safely practice attacks and exploitation techniques.

### Metasploitable2
- A deliberately vulnerable Linux VM built for practicing exploitation with tools like Metasploit.
- **Setup:**
  1. Download the Metasploitable2 `.zip` from the official Rapid7/SourceForge distribution.
  2. Extract and import the included `.vmdk` into VirtualBox/VMware as a new VM.
  3. Boot the VM; default login is `msfadmin` / `msfadmin`.
  4. Note its IP address (`ifconfig`) for later scanning/attacks from Kali.

### DVWA (Damn Vulnerable Web App)
- A PHP/MySQL web application with intentionally weak security, used to practice web attacks (SQLi, XSS, CSRF, etc.) at adjustable difficulty levels.
- **Setup Options:**
  - **Option A — Standalone VM:** Download a pre-built DVWA VM image and import it like the others.
  - **Option B — Manual install:** Install XAMPP/LAMP stack, clone DVWA from its GitHub repo, configure `config.inc.php`, and set up the database via the DVWA setup page.
  - **Option C — Docker:** Run `docker run --rm -it -p 80:80 vulnerables/web-dvwa` for a quick, disposable instance.
- Set the **security level** (Low/Medium/High/Impossible) inside the DVWA web UI to control challenge difficulty.

> Both tools are legal to attack **only within your own isolated lab** — never point these techniques at systems you don't own or have explicit permission to test.

---

## 4. Configure a Private Lab Network (Host-Only Adapter)

To safely practice attacks, your VMs need to talk to **each other** but be isolated from your real home/office network and the internet.

### Why Host-Only Networking?
- **Host-Only Adapter:** Creates a private virtual network between the host machine and VMs — VMs can reach each other and the host, but **not** the outside internet (unless explicitly bridged).
- This prevents:
  - Accidentally attacking real devices on your network.
  - Malware inside vulnerable VMs from "escaping" onto your LAN.

### Setup Steps (VirtualBox example)
1. Go to **File → Host Network Manager** → create a new Host-Only Network (e.g., `vboxnet0`), which auto-assigns a subnet like `192.168.56.0/24`.
2. For each VM (Kali, Metasploitable2, DVWA):
   - Go to **Settings → Network → Adapter 1**
   - Set **"Attached to"** = `Host-only Adapter`
   - Select the network created above (e.g., `vboxnet0`)
3. Boot each VM and verify connectivity:
   - Check IP with `ip a` or `ifconfig` on each machine.
   - From Kali, `ping` the target machine's Host-Only IP to confirm connectivity.
   - Run `nmap -sn 192.168.56.0/24` from Kali to discover all lab hosts.

### Networking Modes Comparison

| Mode | Internet Access | VM-to-VM | VM-to-Host | Use Case |
|---|---|---|---|---|
| **NAT** | Yes | No (isolated) | No | General internet access for one VM |
| **Bridged** | Yes | Yes (same as physical LAN) | Yes | VM acts like a real device on your network (risky for labs) |
| **Host-Only** | No | Yes | Yes | **Best for isolated pentest labs** |
| **Internal Network** | No | Yes | No | Fully isolated VM-to-VM only, no host access |

> **Best practice:** Use **Host-Only** (or **Internal Network** for even stricter isolation) for all lab VMs, and optionally give Kali a second NAT adapter if it needs internet access for tool updates.

---

## 5. Quick Summary Table

| Component | Role | Key Point |
|---|---|---|
| VirtualBox/VMware | Hypervisor | Runs and manages all lab VMs |
| Kali Linux | Attacker machine | Pre-loaded with pentesting tools |
| Metasploitable2 / DVWA | Target machines | Intentionally vulnerable, safe to attack |
| Host-Only Adapter | Networking | Isolates the lab from your real network/internet |

---

## 6. Safety Reminders
- Only attack machines **you own** and that are explicitly designed for this purpose.
- Keep the lab network **isolated** — double-check adapter settings before running any exploits.
- Take **VM snapshots** before major changes so you can easily revert if something breaks.
- Never expose vulnerable VMs (Metasploitable2, DVWA) to the public internet.
