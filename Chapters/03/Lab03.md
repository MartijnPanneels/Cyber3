# Labo03

## SSH Client Config

To change the SSH client config I "C:/Users/.../.ssh/config". This automatically set the config of the ssh correct. To log in, I just can say: `ssh [host]`.

I added the following config to the ssh-file

```bash
Host companyrouter
    HostName 192.168.62.253
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/companyrouter/virtualbox/private_key"
    port 22

Host database
    HostName 172.30.0.15
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/database/virtualbox/private_key"
    port 22
    ProxyJump companyrouter

Host dns
    HostName 172.30.128.7
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/dns/virtualbox/private_key"
    port 22
    ProxyJump companyrouter

Host employee
    HostName 172.30.0.123
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/employee/virtualbox/private_key"
    port 22
    ProxyJump companyrouter

Host web
    HostName 172.30.128.10
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/web/virtualbox/private_key"
    port 22
    ProxyJump companyrouter

Host ipsrouter
    HostName 192.168.62.254
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/ipsrouter/virtualbox/private_key"
    port 22

Host homerouter
    HostName 192.168.62.42
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/homerouter/virtualbox/private_key"
    port 22

Host remote_employee
    HostName 172.10.10.123
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/.vagrant/machines/remote_employee/virtualbox/private_key"
    port 22
    ProxyJump homerouter

Host red
    HostName 192.168.62.43
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/extravms/.vagrant/machines/red/virtualbox/private_key"
    port 22

Host winclient
    HostName 192.168.62.44
    User vagrant
    IdentityFile "C:/Users/marti/Documents/cybersecurity-advanced-lab-template/extravms/.vagrant/machines/winclient/virtualbox/private_key"
    port 22
```

<!-- Example:
When you connect to database through companyrouter:

You connect to companyrouter (using its key)
Companyrouter opens a tunnel to database
You connect to database through that tunnel (using database's key)
Companyrouter just passes the data through - it never sees or needs database's key -->

## SSH Port Forwarding

To do it open a SSH tunnel: `ssh -R 192.168.62.253:3306:172.30.0.15:3306 companyrouter` -> -R = Remote Port Forwarding, 192.168.62.253:3306 = Listen on companyrouter's IP:port, 172.30.0.15:3306 = Forward to database's IP:port, companyrouter = Jump host (uses SSH config)

Leave the terminal of the SSH tunnel open.

In the another terminal, check the connection: `Test-NetConnection -ComputerName 192.168.62.253 -Port 3306`

Output:

```bash
PS C:\Users\marti\Documents\cybersecurity-advanced-lab-template> Test-NetConnection -ComputerName 192.168.62.253 -Port 3306
WARNING: TCP connect to (192.168.62.253 : 3306) failed
```

The port forwarding isn't working. I check if GatewayPort is disabled: `sudo grep GatewayPorts /etc/ssh/sshd_config`
It shows `[vagrant@companyrouter ~]$ sudo grep GatewayPorts /etc/ssh/sshd_config #GatewayPorts no` -> this is default. Port only listens on localhost. Change to GatewayPorts yes -> Port listens on all interfaces

To change it to yes:

1. `sudo sed -i 's/#GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config`
2. `sudo systemctl restart sshd`
3. Verify: `sudo grep GatewayPorts /etc/ssh/sshd_config`

```Powershell
PS C:\Users\marti\Documents\cybersecurity-advanced-lab-template> Test-NetConnection -ComputerName 192.168.62.253 -Port 3306

ComputerName     : 192.168.62.253
RemoteAddress    : 192.168.62.253
RemotePort       : 3306
InterfaceAlias   : Ethernet 12
SourceAddress    : 192.168.62.1
TcpTestSucceeded : True
```

**Why is this an interesting approach from a security point-of-view?**

    - Bypass firewall rules that block direct access.
    - Hard to detect: uses legitimate SSH.

**When would you use local port forwarding?**

    - Use local port forwarding (-L) when you need to access a service on a remote/internal network from your local machine, as if it were running on localhost (Private use).
    - ssh -L 13306:database:3306 companyrouter

**When would you use remote port forwarding?**

    - Use remote port forwarding (-R) when you want a port to listen on the remote side (bastion/server) and forward back to a target service that your local machine can reach (Public use).
    - ssh -R 192.168.62.253:3306:172.30.0.15:3306 companyrouter
      - -R: create a listener on the remote (companyrouter)
      - 192.168.62.253:3306: port that will listen on companyrouter
      - 172.30.0.15:3306: ultimate destination (database) that your local side can reach via the SSH tunnel
      - Anyone who can reach companyrouter:3306 can now reach the database through your tunnel (if GatewayPorts yes).

**Which of the two are more "common" in security?**

Local port forwarding is the more common pattern in security work. Pivoting into internal services during pentests/red teaming.
Remote port forwarding shows up less often, mainly for callbacks/reverse shells from firewalled hosts

**Some people call SSH port forwarding also a "poor man's VPN". Why?**

Because a single SSH session can create encrypted, on-demand tunnels to reach otherwise internal services, so you get VPN-like access without installing a full VPN stack.

---

Create another user for every machine:

1. SSH into the machine
2. Create user `sudo adduser [user-name]`
3. Setup SSH directory:
    1. `sudo mkdir -p /home/[user-name]/.ssh`
    2. `sudo chmod 700 /home/[user-name]/.ssh`
    3. `sudo chown [user-name]:[user-name] /home/[user-name]/.ssh`
4. Verify `id [user-name]`
5. Generate a key-pair
6. Copy the public key to authorized_keys
    1. `sudo vi /home/[user-name]/.ssh/authorized_keys`
    2. Paste in the public-key.
    3. `sudo chmod 600 /home/[user-name]/.ssh/authorized_keys`
    4. `sudo chown [user-name]:[user-name] /home/[user-name]/.ssh/authorized_keys`
7. Change the SSH config

|     Machine     |      User       |
| :-------------: | :-------------: |
|  companyrouter  |   routeradmin   |
|    database     |     dbadmin     |
|       dns       |    dnsadmin     |
|       web       |    webadmin     |
|    employee     |     empuser     |
|    isprouter    | isprouteradmin  |
|   homerouter    | homerouteradmin |
| remote-employee |   remoteuser    |

---

**Example 1: use port forwarding to get to see the webpage from the webserver in the browser on the host (your laptop).**

1. Open a ssh-tunnel: `ssh -L 8080:172.30.128.10:80 companyrouter`
2. Leave the session open.
3. Surf to `http://localhost:8080/`

**Example 2: use port forwarding to access the database from the host (your laptop).**

1. Open a ssh-tunnel: `ssh -L 13306:172.30.0.15:3306 companyrouter`
2. Leave the session open.
3. It is accessible on `localhost:13306`

**Example 3: combine both examples in a single command so you can see the webpage and access the database both at the same time from the host (your laptop).**

1. Open a ssh-tunnel: `ssh -L 8080:172.30.128.10:80 -L 13306:172.30.0.15:3306 companyrouter`
2. Both are now accessible

**Example 4: try to log in on web from the host (your laptop) if you didn't add routes on your host.**

ssh -J companyrouter vagrant@172.30.128.10