# Linux Fundamentals — Study Notes

---

## 1. File System Navigation

Linux organizes everything in a single hierarchical tree starting at the root (`/`). Knowing how to move around this tree is the most basic Linux skill.

### Core Commands

| Command | Purpose | Example |
|---|---|---|
| `pwd` | **P**rint **W**orking **D**irectory — shows your current location | `pwd` → `/home/user/Documents` |
| `ls` | **L**i**s**t contents of a directory | `ls -la` (long format, show hidden files) |
| `cd` | **C**hange **D**irectory | `cd /var/log` |

### Useful `ls` Flags
| Flag | Meaning |
|---|---|
| `-l` | Long listing (permissions, owner, size, date) |
| `-a` | Show hidden files (those starting with `.`) |
| `-h` | Human-readable sizes (KB, MB, GB) |
| `-R` | Recursive — list subdirectories too |

### Useful `cd` Shortcuts
| Shortcut | Meaning |
|---|---|
| `cd ~` or `cd` | Go to home directory |
| `cd ..` | Go up one level |
| `cd -` | Go to the previous directory |
| `cd /` | Go to root directory |

### Other Essential Navigation Commands
| Command | Purpose |
|---|---|
| `mkdir dirname` | Create a new directory |
| `rmdir dirname` | Remove an **empty** directory |
| `touch file.txt` | Create an empty file / update timestamp |
| `cp source dest` | Copy files/directories |
| `mv source dest` | Move or rename files/directories |
| `rm file.txt` | Delete a file (`-r` for directories, `-f` to force) |
| `find /path -name "*.txt"` | Search for files matching a pattern |
| `locate filename` | Fast file search using a pre-built index |

> **Tip:** `.` means "current directory" and `..` means "parent directory" — used constantly in paths like `./script.sh` or `cd ../..`.

---

## 2. File & Directory Permissions

Linux permissions control **who** can read, write, or execute a file — critical for both system stability and security.

### Permission Types
| Symbol | Permission | Effect on File | Effect on Directory |
|---|---|---|---|
| `r` | Read | View file contents | List directory contents |
| `w` | Write | Modify file contents | Add/remove files within it |
| `x` | Execute | Run as a program/script | Enter (`cd` into) the directory |

### Permission Groups
Every file has three sets of permissions, shown in `ls -l` output like `-rwxr-xr--`:

```
-  rwx  r-x  r--
|   |    |    |
|  Owner Group Others
Type
```

| Position | Meaning |
|---|---|
| 1st char | File type (`-` = file, `d` = directory, `l` = symlink) |
| Chars 2–4 | **Owner** permissions |
| Chars 5–7 | **Group** permissions |
| Chars 8–10 | **Others** (everyone else) permissions |

### chmod — Change Permissions

**Symbolic mode:**
```
chmod u+x script.sh      # add execute for owner (user)
chmod g-w file.txt       # remove write for group
chmod o=r file.txt       # set others to read-only
chmod a+rwx file.txt     # add rwx for everyone (all)
```
(`u`=user/owner, `g`=group, `o`=others, `a`=all)

**Numeric (octal) mode:** each permission has a value — `r=4, w=2, x=1` — summed per group.

| Numeric | Meaning |
|---|---|
| `7` | rwx (4+2+1) |
| `6` | rw- (4+2) |
| `5` | r-x (4+1) |
| `4` | r-- |
| `0` | --- (no access) |

```
chmod 755 script.sh   # owner: rwx, group: r-x, others: r-x
chmod 644 file.txt    # owner: rw-, group: r--, others: r--
chmod -R 700 folder/  # recursive, owner-only full access
```

### chown — Change Ownership
```
chown user file.txt              # change owner
chown user:group file.txt        # change owner and group
chown -R user:group folder/      # recursive ownership change
```

### chgrp — Change Group Only
```
chgrp developers file.txt
```

> **Security note:** Avoid `chmod 777` (full access to everyone) except for temporary testing — it's a common misconfiguration that creates serious vulnerabilities.

---

## 3. Package Management

Package managers install, update, and remove software along with their dependencies.

### apt (Advanced Package Tool) — Debian/Ubuntu/Kali

| Command | Purpose |
|---|---|
| `sudo apt update` | Refresh the local package index (list of available versions) |
| `sudo apt upgrade` | Upgrade all installed packages to the latest version |
| `sudo apt full-upgrade` | Upgrade and intelligently handle dependency changes |
| `sudo apt install packagename` | Install a package |
| `sudo apt remove packagename` | Remove a package (keeps config files) |
| `sudo apt purge packagename` | Remove a package **and** its config files |
| `sudo apt autoremove` | Remove unused dependency packages |
| `apt search keyword` | Search available packages |
| `apt list --installed` | List all installed packages |

### dpkg (Debian Package manager) — lower-level tool

`apt` is a friendly front-end for `dpkg`; `dpkg` works directly with `.deb` package files and doesn't resolve dependencies automatically.

| Command | Purpose |
|---|---|
| `sudo dpkg -i package.deb` | Install a local `.deb` file |
| `sudo dpkg -r packagename` | Remove a package |
| `dpkg -l` | List all installed packages |
| `dpkg -L packagename` | List files installed by a package |
| `dpkg -S /path/to/file` | Find which package owns a file |
| `sudo apt --fix-broken install` | Fix dependency errors left by `dpkg -i` |

### apt vs dpkg
| Feature | apt | dpkg |
|---|---|---|
| Dependency resolution | Automatic | Manual |
| Downloads from repositories | Yes | No (needs local `.deb`) |
| Ease of use | High (recommended for daily use) | Low-level (used internally by apt) |

---

## 4. Networking Commands

### ifconfig — Interface Configuration (legacy, replaced by `ip`)
```
ifconfig            # show all active network interfaces
ifconfig eth0       # show details for a specific interface
ifconfig eth0 up    # enable an interface
ifconfig eth0 down  # disable an interface
```
Shows IP address, netmask, MAC address, and packet statistics per interface.
> **Note:** Many modern distros favor the newer `ip addr` / `ip link` commands, but `ifconfig` is still widely taught and used.

### ping — Test Connectivity
```
ping google.com          # send continuous ICMP echo requests
ping -c 4 8.8.8.8         # send exactly 4 packets
```
- Confirms whether a host is reachable and measures round-trip time (latency).
- `Ctrl+C` stops a continuous ping.

### netstat — Network Statistics
```
netstat -tuln     # show listening TCP/UDP ports (numeric, no DNS lookup)
netstat -r        # show routing table
netstat -a        # show all connections and listening ports
netstat -p        # show the process using each connection
```
| Flag | Meaning |
|---|---|
| `-t` | TCP connections |
| `-u` | UDP connections |
| `-l` | Listening ports only |
| `-n` | Show numeric addresses (skip DNS resolution) |

> **Note:** On many modern systems `netstat` is deprecated in favor of `ss` (e.g., `ss -tuln`), but it remains a core troubleshooting tool.

### traceroute — Trace the Path to a Host
```
traceroute google.com
```
- Shows every hop (router) a packet passes through to reach its destination, along with latency at each hop.
- Useful for diagnosing where a connection is slow or failing.
- Windows equivalent: `tracert`.

### Quick Reference Table
| Command | Purpose |
|---|---|
| `ifconfig` | View/configure network interfaces |
| `ping` | Test if a host is reachable |
| `netstat` | View active connections & listening ports |
| `traceroute` | Trace the network path to a destination |

---

## 5. Quick Summary Table

| Category | Key Commands |
|---|---|
| Navigation | `pwd`, `ls`, `cd`, `mkdir`, `rm` |
| Permissions | `chmod`, `chown`, `chgrp` |
| Package Management | `apt`, `dpkg` |
| Networking | `ifconfig`, `ping`, `netstat`, `traceroute` |
