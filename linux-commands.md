# Linux & DevOps Command Cheat Sheet

A comprehensive collection of Linux, DevOps, Docker, AWS CLI, Networking, Process Management, and System Administration commands used daily by Linux Administrators, Cloud Engineers, and DevOps Engineers.

---

# Table of Contents

- [System Information](#system-information)
- [File Management](#file-management)
- [Vim Editor](#vim-editor)
- [Searching Files & Text](#searching-files--text)
- [File Viewing](#file-viewing)
- [User & Group Management](#user--group-management)
- [File Permissions](#file-permissions)
- [Package Management](#package-management)
- [Service Management](#service-management)
- [Archive & Compression](#archive--compression)
- [Networking](#networking)
- [Docker](#docker)
- [SSH](#ssh)
- [Vagrant](#vagrant)
- [AWS CLI](#aws-cli)
- [Disk Management](#disk-management)
- [Process Management](#process-management)
- [System Monitoring](#system-monitoring)
- [Log Analysis](#log-analysis)
- [Website Mirroring](#website-mirroring)
- [Miscellaneous Commands](#miscellaneous-commands)

---

# System Information

## Operating System

```bash
cat /etc/os-release
```

Displays Linux distribution information.

---

## System Uptime

```bash
uptime
```

Shows how long the server has been running.

---

## Memory Usage

```bash
free -h
```

Displays memory usage in a human-readable format.

---

## CPU Information

```bash
cat /proc/cpuinfo
```

Displays CPU details.

Check CPU count:

```bash
nproc
```

macOS

```bash
sysctl -n hw.ncpu
```

---

## Disk Space

```bash
df -h
```

Displays available disk space.

---

# File Management

## List Files

```bash
ls -l
```

Long listing.

```bash
ls -lt
```

Sort by newest.

```bash
ls -ltr
```

Sort by oldest.

```bash
ls -la
```

Show hidden files.

```bash
ls -ld directory
```

Show directory permissions.

---

## Create Symbolic Link

```bash
ln -s /path/to/source shortcut_name
```

Example

```bash
ln -s /opt/devops/test/commands.txt cmds
```

---

## Remove Directory

```bash
rm -rf /home/ansible
```

Deletes a directory and all contents.

---

# Vim Editor

| Command | Description |
|---------|-------------|
| `i` | Insert mode |
| `o` | Insert on a new line |
| `gg` | Go to beginning of file |
| `G` | Go to end of file |
| `0` | Beginning of current line |
| `$` | End of current line |
| `w` | Move forward one word |
| `b` | Move backward one word |
| `5w` | Move forward five words |
| `5b` | Move backward five words |
| `yy` | Copy current line |
| `5yy` | Copy five lines |
| `dd` | Delete current line |
| `5dd` | Delete five lines |
| `p` | Paste |
| `u` | Undo |
| `Ctrl + R` | Redo |
| `/text` | Search forward |
| `?text` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `:w` | Save file |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:set nu` | Show line numbers |

Find and Replace

```vim
:%s/old/new/g
```

---

# Searching Files & Text

## Search inside a file

```bash
grep install filename
```

Case insensitive

```bash
grep -i install filename
```

Recursive search

```bash
grep -Ri install .
```

Exclude matches

```bash
grep -vi install filename
```

Search SELinux configuration

```bash
grep -R SELINUX /etc/*
```

---

## Find Files

```bash
find /etc -name hosts
```

Find files larger than 100MB

```bash
find / -size +100M -type f
```

---

# File Viewing

```bash
cat filename
```

Display file contents.

```bash
less filename
```

Read file with scrolling.

```bash
more filename
```

Simple file reader.

```bash
head filename
```

Show first 10 lines.

```bash
head -15 filename
```

Show first 15 lines.

```bash
tail filename
```

Show last 10 lines.

```bash
tail -15 filename
```

Show last 15 lines.

```bash
tail -f logfile.log
```

Monitor a log file in real time.

---

# User & Group Management

Create user

```bash
adduser username
```

Create group

```bash
groupadd groupname
```

Add user to group

```bash
usermod -aG groupname username
```

Set password

```bash
passwd username
```

Switch user

```bash
su - username
```

Current logged-in users

```bash
who
```

Last login history

```bash
last
```

Delete user

```bash
userdel username
```

Delete user and home directory

```bash
userdel -r username
```

Delete group

```bash
groupdel groupname
```

---

# File Permissions

Change ownership

```bash
chown -R user:group directory
```

Examples

```bash
chmod u+rx directory
chmod g+rx directory
chmod o-x directory
```

Numeric Permissions

| Number | Permission |
|---------|------------|
|4|Read|
|2|Write|
|1|Execute|

Examples

```bash
chmod 640 file.txt
chmod 770 directory
chmod -R 770 directory
```

Edit sudoers file

```bash
visudo
```

---

# Package Management

## Ubuntu / Debian

Update repositories

```bash
apt update
```

Install package

```bash
apt install package-name
```

Search package

```bash
apt search package-name
```

Remove package

```bash
apt remove package-name
```

Remove package including configuration

```bash
apt purge package-name
```

Install local package

```bash
dpkg -i package.deb
```

List installed packages

```bash
dpkg -l
```

---

## CentOS / RedHat

Install package

```bash
yum install package-name
```

Remove package

```bash
yum remove package-name
```

Install RPM

```bash
rpm -ivh package.rpm
```

---

# Service Management

Check status

```bash
systemctl status service
```

Start service

```bash
systemctl start service
```

Stop service

```bash
systemctl stop service
```

Restart service

```bash
systemctl restart service
```

Reload configuration

```bash
systemctl reload service
```

Enable service at boot

```bash
systemctl enable service
```

Check if active

```bash
systemctl is-active service
```

---

# Archive & Compression

Create tar archive

```bash
tar -czvf backup.tar.gz folder
```

Extract archive

```bash
tar -xzvf backup.tar.gz
```

Zip folder

```bash
zip -r backup.zip folder
```

Extract zip

```bash
unzip backup.zip
```

---

# Networking

Ping

```bash
ping hostname -c 4
```

Check listening ports

```bash
netstat -antp
```

Scan host

```bash
nmap hostname
```

DNS lookup

```bash
dig hostname
```

Routing table

```bash
route -n
```

ARP table

```bash
arp -a
```

---

# Docker

Download and run image

```bash
docker run nginx
```

Run detached container

```bash
docker run --name web01 -d -p 9080:80 nginx
```

List images

```bash
docker images
```

Running containers

```bash
docker ps
```

All containers

```bash
docker ps -a
```

Start Docker Compose

```bash
docker compose up -d
```

Stop Compose

```bash
docker compose down
```

Cleanup Docker

```bash
docker system prune -a
```

---

# SSH

Generate SSH key

```bash
ssh-keygen
```

Copy SSH key

```bash
ssh-copy-id user@hostname
```

---

# Vagrant

Initialize project

```bash
vagrant init ubuntu/jammy64
```

List boxes

```bash
vagrant box list
```

Destroy VM

```bash
vagrant destroy --force
```

---

# AWS CLI

Configure credentials

```bash
aws configure
```

Current identity

```bash
aws sts get-caller-identity
```

Describe EC2 instances

```bash
aws ec2 describe-instances
```

Create S3 bucket

```bash
aws s3 mb s3://bucket-name
```

Check S3 bucket size

```bash
aws s3 ls s3://bucket-name --recursive --human-readable --summarize | tail -2
```

---

# Disk Management

List disks

```bash
fdisk -l
```

Partition disk

```bash
fdisk /dev/nvme1n1
```

Format disk

```bash
mkfs.ext4 /dev/nvme1n1
```

Edit fstab

```bash
vi /etc/fstab
```

Mount all filesystems

```bash
mount -a
```

---

# Process Management

View processes

```bash
ps
```

All processes

```bash
ps aux
```

Find process

```bash
ps aux | grep nginx
```

Live monitor

```bash
top
```

Enhanced monitor

```bash
htop
```

Kill process

```bash
kill PID
```

Force kill

```bash
kill -9 PID
```

Kill by name

```bash
killall nginx
```

---

# System Monitoring

Memory

```bash
free -h
```

Disk usage

```bash
df -h
```

Largest directories

```bash
du -sh /* 2>/dev/null | sort -hr
```

Large files

```bash
find / -size +100M -type f
```

Largest log files

```bash
du -sh /var/log/* | sort -hr
```

Directory size

```bash
du -sh /var/www/html/uploads
```

---

# Log Analysis

Find HTTP 5xx errors

```bash
grep 'HTTP/1.1" 5' /var/log/nginx/access.log
```

Today's errors

```bash
grep "$(date +%F)" /var/log/syslog | grep -i error
```

---

# Website Mirroring

Simple mirror

```bash
wget -r -np -k https://example.com
```

Complete mirror

```bash
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent https://example.com
```

---

# Miscellaneous Commands

Count files

```bash
ls | wc -l
```

Count lines

```bash
wc -l /etc/passwd
```

Clear file contents

```bash
cat /dev/null > filename
```

Change default editor to Vim

```bash
export EDITOR=vim
```

Enable Apache/PHPMailer to send mail (SELinux)

```bash
sudo setsebool -P httpd_can_sendmail 1
sudo setsebool -P httpd_can_network_connect 1
```

Recover deleted files (Ubuntu)

```bash
sudo apt install extundelete
sudo extundelete --restore-file /path/to/file /dev/sdX
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to submit pull requests with additional commands, improvements, or corrections.

---

## ⭐ Support

If you find this repository useful, don't forget to **Star** it on GitHub!

---

## 📄 License

Licensed under the MIT License.