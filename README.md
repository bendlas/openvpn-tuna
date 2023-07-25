# OpenVPN Tuna

OpenVPN with ocproxy/tunsocks/VPN-to-proxy/socks2tun support, as well
as AWS VPC support.

Ported from

- https://github.com/ValdikSS/openvpn-tunpipe
- https://github.com/samm-git/aws-vpn-client

# Usage

## Preparation

To get the out-of-the-box experience, you'll need
[Nix](https://nixos.org/) installed.

You don't, however, need to clone the repository. Instead you can just
run it directly from github: e.g. `nix run github:bendlas/openvpn-tuna#server`

Replace `.#` with `github:bendlas/openvpn-tuna#` in the examples, in
order to do so.

First get an OVPN file for your endpoint from the [AWS Client VPN
Self-Service Portal](https://self-service.clientvpn.amazonaws.com/)

## Start the shim server

In a new terminal: Start the go server, that will push the browser
response back to the connection script.

```sh
nix run .#server
```

## Run one or more clients

Then you can use whatever client works for you. Tunsocks is tested.

Each client will be a full, but rootless OpenVPN instance, that runs
the connection script on a proxy pipe, similar to an OpenConnect
script tunnel.

### tunsocks

```sh
nix run .#tunsocks -- /home/user/code/project/tmp/cvpn-endpoint-<vpn-id>.ovpn
```

then check your public ip from within VPN

```sh
curl --socks5-hostname 127.0.0.1:10080 -v https://icanhazip.com/
```

### ocproxy

```sh
nix run .#ocproxy -- /home/user/code/project/tmp/cvpn-endpoint-<vpn-id>.ovpn
```

### ocproxy/vpnns

```sh
nix run .#vpnns -- /home/user/code/project/tmp/cvpn-endpoint-<vpn-id>.ovpn
```

then

```sh
vpnns
```

to get into the isolated vpn network namespace.
