# OpenVPN Server

A lightweight, containerized OpenVPN server built on Alpine Linux with easy-rsa for certificate management.

## Features

- OpenVPN running over UDP port 1194
- AES-256-GCM encryption with SHA-512 authentication
- TLS 1.2+ enforced with HMAC firewall (`tls-auth`)
- Automatic PKI initialization on first start
- Automated client certificate and config generation
- Persistent data via Docker volume

## Requirements

- Docker & Docker Compose
- A host with `/dev/net/tun` available
- Public IP or hostname for remote clients to connect

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── start.sh          # Start the server (first-run safe)
├── create_user.sh    # Generate a client .ovpn config
├── config/
│   └── server.conf
└── scripts/
    ├── start.sh      # Container entrypoint
    └── functions.sh  # initPKI, createConfig helpers
```

## Quick Start

**1. Configure your server's public hostname or IP:**

```bash
export HOST_ADDR=your.server.address
```

**2. Start the server:**

```bash
./start.sh
```

This builds the image, starts the container, and automatically initializes the PKI on the first run. No manual `exec` steps required.

## Generating a Client Config

```bash
./create_user.sh [output.ovpn]
```

If no filename is provided, the config is saved as `client.ovpn` in the current directory.

Import the resulting `.ovpn` file into any OpenVPN-compatible client.

## Environment Variables

| Variable    | Default     | Description                                   |
|-------------|-------------|-----------------------------------------------|
| `HOST_ADDR` | `localhost` | Public IP or hostname clients will connect to |

## Persistent Data

All PKI material and client configs are stored in the `openvpn_data` Docker volume at `/opt/amneziavpn_data` inside the container.

## Security Notes

- Keep `ta.key` and all private keys in the volume secure.
- Rotate client certificates by revoking them with `easyrsa revoke <CLIENT_ID>` and regenerating the CRL.
- The server drops privileges to `nobody:nobody` after startup.

## License

See [LICENSE](LICENSE).

