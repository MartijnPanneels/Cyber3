# Cheat sheet

## Addresstable

|     Machine     |        IP         | Default Gateway |   DNS server   |
| :-------------: | :---------------: | :-------------: | :------------: |
|    isprouter    | 192.168.62.254/24 |    10.0.2.2     | 192.168.25.10  |
|                 |   10.0.2.15/24    |                 | 195.130.131.1  |
|                 |                   |                 | 195.130.130.1  |
|  companyrouter  | 192.168.62.253/24 | 192.168.62.254  |   172.30.0.4   |
|                 | 172.30.255.254/16 |                 |                |
|       red       | 192.168.62.43/24  |    10.0.2.2     | 192.168.25.10  |
|                 |   10.0.2.15/24    |                 | 195.130.131.1  |
|                 |                   |                 | 195.130.130.1  |
|       web       |  172.30.0.10/24   | 172.30.255.254  |   172.30.0.4   |
|       dns       |   172.30.0.4/24   | 172.30.255.254  |    9.9.9.9     |
|                 |                   |                 |    8.8.8.8     |
|                 |                   |                 | 192.168.62.254 |
|     databse     |  172.30.0.15/24   | 172.30.255.254  |    9.9.9.9     |
|                 |                   |                 |    8.8.8.8     |
|                 |                   |                 |   172.30.0.4   |
|    employee     |  172.30.0.123/24  | 172.30.255.254  |    9.9.9.9     |
|                 |                   |                 |    8.8.8.8     |
|                 |                   |                 |   172.30.0.4   |
|   homerouter    | 192.168.62.42/24  | 192.168.62.254  | 192.168.62.254 |
|                 | 172.10.10.254/24  |                 |                |
| remote-employee | 172.10.10.123/24  |  172.10.10.254  | 192.168.62.254 |

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
