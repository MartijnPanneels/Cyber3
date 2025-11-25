# Lab02

## The insecure "fake internet" host only network

**Use a web browser to browse to http://www.cybersec.internal**

    I can visit the site when my DNS is set to 172.30.0.4

**Use a web browser to browse to http://www.cybersec.internal/cmd and test out this insecure application.**

    `pwd` en `ls` -> we are in the root folder.

**Perform a default nmap scan on all machines.**

isprouter:

PORT STATE SERVICE
22/tcp open ssh
53/tcp open domain
MAC Address: 08:00:27:AF:92:9F (PCS Systemtechnik/Oracle VirtualBox virtual NIC)

companyrouter:

PORT STATE SERVICE
22/tcp open ssh
111/tcp open rpcbind
MAC Address: 08:00:27:8A:14:4E (PCS Systemtechnik/Oracle VirtualBox virtual NIC)

dns:

PORT STATE SERVICE
22/tcp open ssh
53/tcp open domain

web:

PORT STATE SERVICE
22/tcp open ssh
80/tcp open http
111/tcp open rpcbind
8000/tcp open http-alt

databse:

PORT STATE SERVICE
22/tcp open ssh
3306/tcp open mysql

employee:

PORT STATE SERVICE
22/tcp open ssh

homerouter:

PORT STATE SERVICE
22/tcp open ssh
111/tcp open rpcbind
MAC Address: 08:00:27:88:3B:48 (PCS Systemtechnik/Oracle VirtualBox virtual NIC)

remote_employee:

PORT STATE SERVICE
22/tcp open ssh
111/tcp open rpcbind

**Enumerate the most interesting ports (you found in the previous step) by issuing a service enumeration scan (bannergrab scan).**

**What database software is running on the database machine? What version?**

`nmap -sV 172.30.0.15`

PORT STATE SERVICE VERSION
22/tcp open ssh OpenSSH 9.3 (protocol 2.0)
3306/tcp open mysql MariaDB 5.5.5-10.11.11

**Try to search for a nmap script to brute-force the database. Another (even easier tool) is called hydra (https://github.com/vanhauser-thc/thc-hydra). Search online for a good wordlist. For example "rockyou" or https://github.com/danielmiessler/SecLists We suggest to try the default username of the database software and attack the database machine. Another interesting username worth a try is "toor".**

1. I found the rockyou wordlist but it is still zipped -> `sudo gunzip /usr/share/wordlists/rockyou.txt.gz`
2. Hydra is already installed on Kali linux. I used `hydra -l root -P /usr/share/wordlists/rockyou.txt -s 3306 -f -t 16 -W 1 172.30.0.15 mysql`. That didn't work.
3. For the second try I used `hydra -l toor -P /usr/share/wordlists/rockyou.txt -s 3306 -f -t 16 -W 1 172.30.0.15 mysql`. This time it worked!
4. I got the credentials "toor" "summer"
5. To check I logged in `mysql -h 172.30.0.15 -u toor -psummer` and I'm in.

**Try to SSH (using vagrant/vagrant) from red to another machine. Is this possible?**

I tried to ssh in the db. This worked. Same for the web.

**What webserver software is running on web?**

I will use nmap for this. `nmap -sV 172.30.0.10` --> Apache httpd 2.4.62 ((AlmaLinux))

**Try the -sC option with nmap. Do you remember what this option is?**

The -sC option in nmap runs the default script scan. It executes Nmap's most common and useful scripts against the target.

**Important: after trying to figure this one out using nmap from the red machine. Shift your view from a red teamer to a blue teamer. Log in to the web machine and try to figure out, in detail (!), how the webserver is configured. What software is used? Is it static content? Is there java, c#, .NET, php, nodejs... ? Are systemd-unit files used as services? Document this properly!**

- There is an Apache HTTPd on port 80 and a Java application on port 8000 (`ss -tulnp`)
- Webserver: Apache HTTPD 2.4.62 (`cat /etc/httpd/conf/httpd.conf`)
- ServerName: www.cybersec.inernal
- In /var/www/html is the index.html
- openjdk version "17.0.16" 2025-07-15 LTS
- Python 3.9.21



## Network Segmentation¶

**As you can see, a hacker on this host-only network, has no restrictions to interact with the other machines. This is not a best-practice! It looks like there is no difference between the attacker being inside "the internal network" or in the "fake internet network". In practice this means there is not a firewall configured to schield the internal network from the big bad world outside (in this case - once again to stress the important - the "fake internet" network). A way to resolve this issue, is by using and configuring a firewall. This is a network-based firewall. Host-based firewalling is also important, but they are 2 different things! When configuring a firewall, it is import to perform what is called network segmentation. By dividing the network in several segments (often also called "zones") and properly configuring the access to and from these segments (often subnets) you can reduce the attack vector a lot!**

**What is meant here with the term "attack vector"?**

An attack vector is a path or method by which an attacker can gain unauthorized access to a network, system, or data to deliver a malicious payload or carry out an attack.

**Is there already network segmentation done on the (internal) company network?**

    Remember what a DMZ is? What machines would be in the DMZ in this environment? Are there multiple ways to configure this?
    What could be annoying when using network segmentation? Tip in our case: take a look at client <-> server interaction.

Configure the environment, and especially the companyrouter, to make sure that the red machine is not able to interact with most systems anymore. No (network) changes should be done to the red machine! The only requirements that are left for the red machine are:

    Browsing to http://www.cybersec.internal should work. The website of the company should be available from outside the internal network as well. Note: you are allowed to manually add a DNS entry to the red machine to tell the system how to resolve "www.cybersec.internal" if necessary. Try to be mindful why/when this is needed!
    All machines in the company network should still have internet access.
    You should verify what functionality you might lose by implementing the network segmentation. List out and create an overview.
    You should be able to revert back easily: Create proper documentation!

Firewall¶

You are free to choose how you will implement this, but be sure you are able to explain your reasoning. Document everything properly before making changes to existing configuration files. We suggest to use your knowledge of virtualbox as well. The goal of this exercise is to configure companyrouter as a firewall, more specifically a network-based firewall. Software that can help is for example firewall-cmd, ufw, iptables or nftables.

Tip: Although iptables is still used, the Linux world is shifting towards it's spiritual successor nftables as it has more features and is easier to configure.

Tip: While firewall-cmd is really good as an easy to use firewall for clients or single hosts (= host-based firewall), it might not be the preferred choice for our use case. Development is still ongoing, so better support can come (or maybe it is already here).

Conclusion: although we think there is value in the ability of reading and interpreting iptables (which these days AI can help you with), we do recommend the use of nftables for this lab.
Open, closed, filtered ports¶

Finish this lab exercise by performing a nmap scan to web on ports 80, 22 and 666. For port 80 you should see "open", what do you notice on port 22 and 666? Can you explain this result? Make your firewall insecure again (you should be able to do this easily!) and rerun the scan, analyse the differences. We expect you to learn and know the difference between open/closed/filtered!
