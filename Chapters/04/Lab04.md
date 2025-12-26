# Lab04

## Cowrie

1. **Why is companyrouter, in this environment, an interesting device to configure with a SSH honeypot? What could be a good argument to NOT configure the router with a honeypot service?**

It is the first point of contact for external attackers. It is a high-value target. It can give early warnings before the traffic reaches the DMZ and the internal network.

Honeypots are typically deployed on separate dedicated hosts that can be isolated and don't impact production traffic. Single point of failure risk.

2. **Change your current SSH configuration in such a way that the SSH server (daemon) is not listening on port 22 anymore but on port 2222.**

The ssh-configuration can be changed `vi /etc/ssh/sshd_config`. Set "#Port 22" to "Port 2222"

When the port is changed I could not restart sshd. I need to add port 2222 to SELinux `sudo semanage port -a -t ssh_port_t -p tcp 2222`. After that I can restart sshd `sudo systemctl restart sshd`.

Verify:

```bash
[vagrant@companyrouter ~]$ sudo ss -tlnp | grep sshd
LISTEN 0      128          0.0.0.0:2222      0.0.0.0:*    users:(("sshd",pid=18301,fd=3))
LISTEN 0      128             [::]:2222         [::]:*    users:(("sshd",pid=18301,fd=4))
```

Lastly I need to change the ssh config file. The port needs to be changed from 22 to 2222.

3. **Install and run the cowrie software on the router and listen on port 22 - the default SSH server port.**

I will set Cowrie up using Docker.

`sudo docker run -d --name cowrie -p 22:2222 cowrie/cowrie:latest`

Verify:

```bash
[vagrant@companyrouter ~]$ sudo docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                               NAMES
57d983977bf3   cowrie/cowrie:latest   "/cowrie/cowrie-env/…"   9 minutes ago   Up 9 minutes   2223/tcp, 0.0.0.0:22->2222/tcp, [::]:22->2222/tcp   cowrie
```

```bash
[vagrant@companyrouter ~]$ sudo ss -tlnp | egrep ':(22|2222)\b'
LISTEN 0      4096         0.0.0.0:22        0.0.0.0:*    users:(("docker-proxy",pid=18873,fd=7))
LISTEN 0      128          0.0.0.0:2222      0.0.0.0:*    users:(("sshd",pid=18301,fd=3))
LISTEN 0      4096            [::]:22           [::]:*    users:(("docker-proxy",pid=18878,fd=7))
LISTEN 0      128             [::]:2222         [::]:*    users:(("sshd",pid=18301,fd=4))
```

4. **Once configured and up and running, verify that you can still SSH to the router normally, using port 2222.**

You can still ssh using port 2222.

5. **Attack your router and try to SSH normally. What do you notice?**

    1. **What credentials work? Do you find credentials that don't work?**

    root:1234 did work

    2. **Do you get a shell?**

    I got a shell `root@svr04:~#`

    3. **Are your commands logged? Is the IP address of the SSH client logged? If this is the case, where?**

    The commands are logged in the docker logs: `sudo docker logs -f cowrie`

    4. **Can an attacker perform malicious things?**

    Since a honeypot is called a deception layer, it protects the real device underneath. No real malware execution or no privilege escalation. It gives fake output.

    5. **Are the actions, in other words, the commands, logged to a file? Which file?**

    The defender can see all the commands typed using the docker logs.

    6. **If you are an experienced hacker, how would/can you realize this is not a normal environment?**

    logincredentials, try install something but can ping to 8.8.8.8, write something in a file using nano or vi.

## Critical thinking (security) when using "Docker as a service"

1. **What are some (at least 2) advantages of running services (for example cowrie but it could be sql server as well) using docker?**

    Isolation: Each container runs independently with its own filesystem, processes, and network namespace. Limited risk of the host system.
    Ease of deployment: Easy to set up and works on every machine
    Reproducibility: Dockerfile describes the exact environmnet.

2. What could be a disadvantage? Give at least 1.

    All containers share the same Linux kernel (the one of the host). A kernel exploit affect all containers.
    To be fully isolated, a virtual machine is a better pick.

3. Explain what is meant with "Docker uses a client-server architecture."

    The docker client is your interface. When you use `docker ps` or `docker logs`, you are talking to the client

    The docker deamon: dockerd is a service that acually manages containers, images, netowks,...

    The clinet sends API requests to the deamon over the socket/TCP.

4. As which user is the docker daemon running by default? Tip: https://docs.docker.com/engine/install/linux-postinstall/.

    It runs as root by default.

5. What could be an advantage of running a honeypot inside a virtual machine compared to running it inside a container

    No shared kernel so a kernel exploit doesn't affect the host. It is also easier to rollback to a clean state.

### Docker deepdive

`docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts`

1. **Why is the socket mounted**

Portainer needs to be able to talk to the docker deamon API to manage containers, images,... -> mounting /var/run/docker.sock gives it that control channel.

2. **What is docker.sock**

It is a file that apps use to talk to the docker deamon. It is a local endpoint for the docker REST API.

3. **According to some people this might cause a real security implications. Can you explain why?**

Dockerd runs as root on host. You can pull images and run them, mount /,... Therefore exposing docker.sock to an untrusted container is giving root priviliges on the host.

## Other honeypots

1. **What type of honeypot is "honeyup"?**

    Web honeypot: An uploader honeypot designed to look like poor website security.

2. **What is the idea behind "opencanary"?**

    Modular and decentralised honeypot daemon that runs several canary versions of services that alerts when a service is (ab)used. It runs fake services to detect intrusion attempts.

3. **Is a HTTP(S) honeypot a good idea? Why or why not?**

    Yes, ports 80 and 443 are constantly scanned. You'll catch reconnaissance, vulnerability scanning, and exploitation attempts immediately.

    **Our webserver isn't really a honeypot. But let's for a second assume our /cmd endpoint is a honeypot. How can we easily retrieve the commands that a hacker inserted in the form? Is this feasible?**

    We could log every entry in a file or database. You can capture the IP and the commands. It is perfect for a honeypot.
