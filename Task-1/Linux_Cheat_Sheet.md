# Linux Command Cheat Sheet

---

## File System Navigation
| Command | Description |
|---|---|
| `pwd` | Print current directory |
| `ls -la` | List all files (incl. hidden), long format |
| `cd /path` | Change directory |
| `cd ~` / `cd` | Go to home directory |
| `cd ..` | Go up one level |
| `cd -` | Go to previous directory |
| `mkdir dir` | Create directory |
| `mkdir -p a/b/c` | Create nested directories |
| `rmdir dir` | Remove empty directory |
| `tree` | Show directory structure as a tree |

---

## File Operations
| Command | Description |
|---|---|
| `touch file` | Create empty file / update timestamp |
| `cp src dest` | Copy file |
| `cp -r src dest` | Copy directory recursively |
| `mv src dest` | Move or rename |
| `rm file` | Delete file |
| `rm -rf dir` | Force-delete directory recursively (use with caution) |
| `cat file` | Print file contents |
| `less file` | View file page-by-page |
| `head -n 20 file` | Show first 20 lines |
| `tail -n 20 file` | Show last 20 lines |
| `tail -f file` | Live-follow file (e.g., logs) |
| `find /path -name "*.txt"` | Search for files by name |
| `locate filename` | Fast indexed file search |
| `wc -l file` | Count lines in a file |
| `diff file1 file2` | Compare two files |
| `ln -s target linkname` | Create a symbolic link |

---

## Permissions & Ownership
| Command | Description |
|---|---|
| `chmod 755 file` | Set permissions (owner rwx, group/others r-x) |
| `chmod +x file` | Add execute permission |
| `chmod -R 700 dir` | Recursive permission change |
| `chown user:group file` | Change owner and group |
| `chgrp group file` | Change group only |
| `umask` | Show/set default permission mask |

**Permission values:** `r=4, w=2, x=1` → sum per group (owner/group/others)

---

## Package Management (Debian/Ubuntu/Kali)
| Command | Description |
|---|---|
| `sudo apt update` | Refresh package index |
| `sudo apt upgrade` | Upgrade installed packages |
| `sudo apt install pkg` | Install a package |
| `sudo apt remove pkg` | Remove a package |
| `sudo apt purge pkg` | Remove package + config files |
| `sudo apt autoremove` | Remove unused dependencies |
| `apt search keyword` | Search for a package |
| `dpkg -i package.deb` | Install a local .deb file |
| `dpkg -l` | List installed packages |
| `dpkg -L pkg` | List files owned by a package |

---

## Networking
| Command | Description |
|---|---|
| `ifconfig` / `ip a` | Show network interfaces |
| `ip link set eth0 up` | Enable an interface |
| `ping -c 4 host` | Send 4 ICMP pings |
| `netstat -tuln` | Show listening ports |
| `ss -tuln` | Modern replacement for netstat |
| `traceroute host` | Trace route to a host |
| `nslookup domain` | DNS lookup |
| `dig domain` | Detailed DNS lookup |
| `curl url` | Fetch a URL / test an endpoint |
| `wget url` | Download a file |
| `scp file user@host:/path` | Copy file over SSH |
| `ssh user@host` | Remote login via SSH |
| `hostname -I` | Show local IP address(es) |

---

## Process Management
| Command | Description |
|---|---|
| `ps aux` | List all running processes |
| `top` / `htop` | Live process monitor |
| `kill PID` | Terminate a process by ID |
| `kill -9 PID` | Force-kill a process |
| `killall name` | Kill all processes matching a name |
| `bg` / `fg` | Send job to background / bring to foreground |
| `jobs` | List background jobs |
| `nohup cmd &` | Run command immune to hangups, in background |
| `systemctl status service` | Check service status |
| `systemctl start/stop/restart service` | Control a service |

---

## Users & Permissions Management
| Command | Description |
|---|---|
| `whoami` | Show current user |
| `id` | Show user/group IDs |
| `sudo cmd` | Run command as superuser |
| `su - user` | Switch user |
| `useradd username` | Create a new user |
| `passwd username` | Set/change a user's password |
| `userdel username` | Delete a user |
| `groups username` | Show a user's groups |

---

## Disk & System Info
| Command | Description |
|---|---|
| `df -h` | Disk space usage (human-readable) |
| `du -sh dir` | Size of a directory |
| `free -h` | Memory usage |
| `uname -a` | Kernel/system information |
| `lsblk` | List block devices/partitions |
| `mount` / `umount` | Mount/unmount a filesystem |
| `uptime` | System uptime and load average |

---

## Archives & Compression
| Command | Description |
|---|---|
| `tar -cvf archive.tar dir/` | Create a tar archive |
| `tar -xvf archive.tar` | Extract a tar archive |
| `tar -czvf archive.tar.gz dir/` | Create gzip-compressed archive |
| `tar -xzvf archive.tar.gz` | Extract gzip-compressed archive |
| `zip -r archive.zip dir/` | Create a zip archive |
| `unzip archive.zip` | Extract a zip archive |

---

## Text Processing & Search
| Command | Description |
|---|---|
| `grep "pattern" file` | Search for text in a file |
| `grep -r "pattern" dir/` | Recursive search |
| `grep -i "pattern" file` | Case-insensitive search |
| `sed 's/old/new/g' file` | Find and replace text |
| `awk '{print $1}' file` | Print a column from text |
| `sort file` | Sort lines |
| `uniq file` | Remove duplicate adjacent lines |
| `cut -d',' -f1 file` | Extract a field (e.g., CSV column) |

---

## Shortcuts & Pipes
| Symbol | Meaning |
|---|---|
| `\|` | Pipe output of one command into another |
| `>` | Redirect output (overwrite) |
| `>>` | Redirect output (append) |
| `<` | Redirect input from a file |
| `&&` | Run next command only if previous succeeded |
| `;` | Run commands sequentially regardless of success |
| `&` | Run command in background |
| `Ctrl + C` | Kill current running command |
| `Ctrl + Z` | Suspend current running command |
| `Ctrl + R` | Search command history |
| `!!` | Repeat last command |
| `man command` | Open manual page for a command |
