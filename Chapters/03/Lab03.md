# Labo03

## SSH client config

To change the SSH client config I "C:\Users\...\.ssh\config". This automatically set the config of the ssh correct. To log in, I just can say: `ssh [host]`.

I added the following config to the ssh-file

```bash
Host companyrouter
    HostName 192.168.62.253
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\companyrouter\virtualbox\private_key"
    port 22

Host database
    HostName 172.30.0.15
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\database\virtualbox\private_key"
    port 22
    ProxyJump companyrouter

Host dns
    HostName 172.30.128.7
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\dns\virtualbox\private_key"
    port 22
    ProxyJump companyrouter

Host employee
    HostName 172.30.0.123
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\employee\virtualbox\private_key"
    port 22
    ProxyJump companyrouter

Host web
    HostName 172.30.128.10
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\web\virtualbox\private_key"
    port 22
    ProxyJump companyrouter

Host ipsrouter
    HostName 192.168.62.254
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\ipsrouter\virtualbox\private_key"
    port 22

Host homerouter
    HostName 192.168.62.42
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\homerouter\virtualbox\private_key"
    port 22

Host remote_employee
    HostName 172.10.10.123
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\.vagrant\machines\remote_employee\virtualbox\private_key"
    port 22
    ProxyJump homerouter

Host red
    HostName 192.168.62.43
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\extravms\.vagrant\machines\red\virtualbox\private_key"
    port 22

Host winclient
    HostName 192.168.62.44
    User vagrant
    IdentityFile "C:\Users\marti\Documents\cybersecurity-advanced-lab-template\extravms\.vagrant\machines\winclient\virtualbox\private_key"
    port 22
```
