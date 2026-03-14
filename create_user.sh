#!/bin/bash

set -e

OUTPUT="${1:-client.ovpn}"

echo "Generating VPN client configuration..."

CLIENT_PATH=$(docker compose exec -T openvpn bash -c "source ./functions.sh && createConfig" | tail -1)

if [ -z "$CLIENT_PATH" ]; then
    echo "Error: Failed to generate client configuration." >&2
    exit 1
fi

docker compose cp "openvpn:${CLIENT_PATH}/client.ovpn" "./${OUTPUT}"

echo "Client config saved to: ${OUTPUT}"
