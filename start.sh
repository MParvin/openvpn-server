#!/bin/bash

set -e

echo "Starting OpenVPN server..."
docker compose up -d

echo "Waiting for the container to initialize..."
docker compose logs -f --no-log-prefix openvpn | while IFS= read -r line; do
    echo "$line"
    if echo "$line" | grep -q "PKI initialized successfully\|Initialization Sequence Completed"; then
        pkill -P $$ -f "docker compose logs" 2>/dev/null || true
        break
    fi
done

echo ""
echo "OpenVPN server is ready."
echo "Use ./create_user.sh [output.ovpn] to generate a client config."
