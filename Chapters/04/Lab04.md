# Lab04

## Cowrie

I will set Cowrie up using Docker.

1. **Why is companyrouter, in this environment, an interesting device to configure with a SSH honeypot? What could be a good argument to NOT configure the router with a honeypot service?**

2. **Change your current SSH configuration in such a way that the SSH server (daemon) is not listening on port 22 anymore but on port 2222.**
3. **Install and run the cowrie software on the router and listen on port 22 - the default SSH server port.**
4. **Once configured and up and running, verify that you can still SSH to the router normally, using port 2222.**
5. **Attack your router and try to SSH normally. What do you notice?**
    1. **What credentials work? Do you find credentials that don't work?**
    2. **Do you get a shell?**
    3. **Are your commands logged? Is the IP address of the SSH client logged? If this is the case, where?**
    4. **Can an attacker perform malicious things?**
    5. **Are the actions, in other words, the commands, logged to a file? Which file?**
    6. **If you are an experienced hacker, how would/can you realize this is not a normal environment?**
