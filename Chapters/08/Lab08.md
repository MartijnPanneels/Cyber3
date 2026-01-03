# Lab08

## Setup

**Check if IP forwarding is enabled**

    - `sysctl net.ipv4.ip_forward`

**Add Routes on Homerouter to Company Networks**

    - Internal company network via companyrouter: `sudo nmcli connection modify "System eth1" +ipv4.routes "172.30.0.0/17 192.168.62.253"`
    - DMZ via companyrouter: `sudo nmcli connection modify "System eth1" +ipv4.routes "172.30.128.0/28 192.168.62.253"`
    - `sudo nmcli connection up "System eth1"

**Add Route on Companyrouter to Home Network**

    - Employee home network via homerouter: `sudo nmcli connection modify "System eth1" +ipv4.routes "172.10.10.0/24 192.168.62.42"`
    - `sudo nmcli connection up "System eth1"`

**Change the firewall configuration**

    [firewall.txt](../../firewall.txt)

**Verify routes**

    - Check internet: `ping -c 2 8.8.8.8`
    - Check DNS: `ping -c 2 google.com`
    - Check internal network: `ping -c 2 172.30.0.15`
    - Check DMZ: `ping -c 2 172.30.128.10`
    - Check connection between routers: `tracepath 172.30.0.15`
