# Cheat sheet

## Network overview

Internal Network:
172.30.0.0/17 -> 172.30.0.1 – 172.30.127.254

DMZ:
172.30.128.0/28 -> 172.30.128.1 – 172.30.128.14

## Change routes

database: `sudo vi /etc/network/interfaces` -> `sudo systemctl restart networking`

employee: `sudo vi /etc/network/interfaces` -> `sudo /etc/init.d/networking restart`

companyrouter: `sudo vi /etc/sysconfig/network-scripts/ifcfg-eth3` -> `sudo systemctl restart NetworkManager`

web: `sudo vi /etc/sysconfig/network-scripts/ifcfg-eth3` -> `sudo systemctl restart NetworkManager`

dns: `sudo vi /etc/network/interfaces` -> `sudo /etc/init.d/networking restart` -> change the dns of cyber.internal to the new ip (`/var/bind/cybersec.internal`), `sudo rc-service named restart`

Change the DNS ip of the red machine: `sudo vi /etc/resolv.conf` -> `sudo chattr +i /etc/resolv.conf`

## Commands

### Package manager apk

|       Task        |         Commands         |
| :---------------: | :----------------------: |
| install a package | `sudo apk add [package]` |

### Change keyboard-layout

`sudo setup-keymap` -> `be` -> `be-iso-alternate` or `sudo localectl setup-keymap be`

### DNS

For red: check /etc/resolv.conf

_nslookup works on Linux and Windows, host and dig only works on Linux_

|                   Task                   |               Commands               |
| :--------------------------------------: | :----------------------------------: |
|              Resolve an URL              |           `nslookup [url]`           |
| Resolve an URL using specific DNS-server | `nslookup [url] [ip/name-dnsserver]` |
|  Resolve an URL with extra information   |        `dig +short NS [url]`         |
|         Reverse lookup using dig         |            `dig -x [ip]`             |
