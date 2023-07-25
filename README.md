# OpenVPN Tuna

OpenVPN with ocproxy/tunsocks/VPN-to-proxy/socks2tun support, as well as AWS VPC support.

Ported from

- https://github.com/ValdikSS/openvpn-tunpipe
- https://github.com/samm-git/aws-vpn-client

# Usage example

Using ocproxy's `vpnns`, without root or other elevated privileges, you can

```sh
openvpn --config config.ovpn --dev "| HOME=$HOME vpnns --attach"
```

and in a second terminal

```sh
vpnns
```

to get into the isolated vpn network namespace.

For AWS support, see https://github.com/bendlas/aws-vpn-client
