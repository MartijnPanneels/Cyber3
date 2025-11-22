# Lab 01

## Recap DNS: basic DNS queries

    See cheatsheet

## Recap Wireshark

-   What layers of the OSI model are captured in this capturefile?

    L2 -> L7

-   Take a look at the conversations. What do you notice?

    Most of the packages were sent from 172.30.128.10 to 172.30.42.2.

-   Take a look at the protocol hierarchy. What are the most "interesting" protocols listed here?

    DNS, HTTP, data

-   Can you spot an SSH session that got established between 2 machines? List the 2 machines. Who was the SSH server and who was the client? What ports were used? Are these ports TCP or UDP?

    172.30.128.10 (client), 172.39.42.2 (server). src port: 37700 dst port: 22, TCP ports

-   Some cleartext data was transferred between two machines. Can you spot the data? Can you deduce what happened here?

    Between 172.30.128.10 and 192.168.56.199. A picture, ls from the / -> answer, pwd -> answer: /home/vagrant, whoami -> answer: root, uname -a -> answer: linux red kali5, cat /etc/passwd -> answer: answer, exit

-   Someone used a specific way to transfer a png on the wire. Is it possible to export this png easily? Is it possible to export other HTTP related stuff?

    Yes: File -> Export obejcts -> Http -> choose the image/png pakcets -> open preview
    Yes, text/html, text/javascript, application/json, text/plain -> we see 'cmd' 'ip a'

## Capture traffic using the CLI

`ssh vagrant@192.168.62.253` -> `sudo dnf install tcpdump` -> `ip a` -> `sudo tcpdump -i eth2 src 172.30.0.123`

-   Have a look at the ip configurations of the dns machine, the employee client and the companyrouter.

    dns: eth1 172.30.0.4/24,
    employee: eth1 172.30.0.123/24,
    companyrouter: eth1 192.168.62.253/24, eth2 172.30.255.254/16

-   Which interface on the companyrouter will you use to capture traffic from the dns to the internet?

    eth1: This is the WAN interface that connects to the "internet".

-   Which interface on the companyrouter would you use to capture traffic from dns to employee?

    eth2: internal company network.

-   Test this out by pinging from employee to the companyrouter and from employee to the dns. Are you able to see all pings in tcpdump on the companyrouter?

    `ping 172.30.255.254` -> you can see the pings
    `ping 172.30.0.4` -> you cant see the pings

-   Figure out a way to capture the data in a file. Copy this file from the companyrouter to your host and verify you can analyze this file with wireshark (on your host).

    `sudo timeout 30 tcpdump -i eth2 -w /vagrant/capture.pcap`

-   SSH from employee to the companyrouter. When scanning with tcpdump you will now see a lot of SSH traffic passing by. How can you start tcpdump and filter out this ssh traffic?

    `sudo timeout 30 tcpdump -i eth2 not port 22 -w /vagrant/capture.pcap`

-   Start the web VM. Find a way to capture only HTTP traffic and only from and to the webserver-machine. Test this out by browsing to http://www.cybersec.internal from the isprouter machine using curl. This is a website that should be available in the lab environment. Are you able to see this HTTP traffic? Browse on the employee client, are you able to see the same HTTP traffic in tcpdump, why is this the case?

    `sudo timeout 15 tcpdump -i eth2 host 172.30.0.10 and port 80`

    employee → companyrouter (eth2) → webserver: you can see the HTTP

    isprouter → companyrouter (eth1) → internal routing → webserver: you can't see the HTTP packets because http://www.cybersec.internal could not be resolved, if we use 172.30.0.10 we can see the HTTP packets

-   Did you notice the website is using HTTP? In a future lab you will be tasked with configuring HTTPS.

    yes, 172.30.0.10.http

## Understanding the network + Attacker machine red

### Part 1

The red machine is configured using the vagrantfile.

### Part 2

**What did you have to configure on your red machine to have internet and to properly ping the web machine (is the ping working on IP only or also on hostname)?**

I configured a virtualbox-NAT interface so the red machine has internet. To communicate to the fake internet I added the Host-only adapter. I did not add the internal adapter but I added a route on the red machine to communicate to the internal network. The route goes to the next hop (company router).

**What is the default gateway of each machine? What is the DNS server of each machine? Which machines have a static IP and which use DHCP?**

For the adresses of the machines -> [cheat-sheet.md](../../cheat-sheet.md)

To get the info:

`ìp a`, `ip r`, `cat /etc/resolv.conf`, `nmcli dev show | grep DNS`

**What (static) routes should be configured and where, how do you make it persistent?**

```bash
┌──(vagrant㉿red)-[~]
└─$ nmcli connection modify eth1 ipv4.addresses 192.168.62.43/24
nmcli connection modify eth1 ipv4.gateway 192.168.62.253
nmcli connection modify eth1 ipv4.routes "172.30.0.0/16 192.168.62.253"
nmcli connection modify eth1 ipv4.method manual
nmcli connection up eth1
```
