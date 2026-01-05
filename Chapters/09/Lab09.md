# Lab09

## Setup

Setup openVPN on the companyrouter.

To install:

1. `sudo dnf install epel-release`
2. `sudo dnf install --assumeyes openvpn easy-rsa`

To find the executable: `find /usr -name easyrsa 2>/dev/null` -> "/usr/share/easy-rsa/3.2.1/easyrsa"

Setup the PKI Directory

1. `mkdir -p ~/openvpn`
2. `cd ~/openvpn` (all the ./ commands are in this folder)
3. `cp -r /usr/share/easy-rsa/3.2.1/* .`

## Initialize the PKI:

In the openvpn folder execute the init: `./easyrsa init-pki`.

Setup the Certificate Authority: `./easyrsa build-ca nopass` (Common Name: "OpenVPN-CA"), nopass is to create the CA without a password.

In the "pki/" directory should be a ca.crt and in the "pki/private/" the ca.key

Setup the Certificate Server: `./easyrsa gen-req server nopass` (Common Name: "OpenVPN-Server")

`./easyrsa sign-req server server`, "yes" to confirm.

In the "pki/issued" directory should be the signed certificate server.crt and in the "pki/private/" the server.key.

To generate Diffie-Hellman Parameters: `./easyrsa gen-dh`-> it creates "pki/dh.pem"

Verify the server certificate using openssl: `sudo openssl verify -CAfile /home/vagrant/openvpn/pki/ca.crt  /home/vagrant/openvpn/pki/issued/server.crt`

## Generate the client keys and certificate

_Also create ~/openvpn directory on the client_

Setup the client: `./easyrsa gen-req client nopass` (Common Name: OpenVPN-Client). Creates private key: "./pki/private/client.key" and the certificate request "./pki/reqs/client.req"

Now the server needs to sign the client.req

Copy paste the client.req on the server and sign it:

-   `cd ~/openvpn`
-   `sudo vi client.req` (paste it here)
-   `sudo ./easyrsa sign-req client client`
<!-- -   Paste the signed certificate back on the client Start with this -->

### Q's

-   Diffie-Hellman parameters allow the server and client to securely agree on a shared, secret encryption key over an insecure network.
-   Easy-RSA is more practical. It was more user-friendly.

## Configure the server

The configuration files are in: "/usr/share/doc/openvpn/sample/sample-config-files/"

`sudo vi /usr/share/doc/openvpn/sample/sample-config-files/server.conf`

<!-- setup client remote employee as client -->
