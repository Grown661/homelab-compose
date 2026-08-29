#!/usr/bin/env bash
# manage.sh — thin wrapper around docker compose for this stack.
# Usage: ./manage.sh {up|down|logs|pull|ps|backup}
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

cmd="${1:-help}"

case "$cmd" in
  up)     docker compose up -d ;;
  down)   docker compose down ;;
  ps)     docker compose ps ;;
  logs)   docker compose logs -f --tail=100 "${2:-}" ;;
  pull)   docker compose pull && docker compose up -d ;;
  backup)
    # Dump the uptime-kuma volume into ./backups/<date>.tar.gz
    mkdir -p backups
    out="backups/uptime-kuma-$(date +%F).tar.gz"
    docker run --rm \
      -v homelab_uptime-kuma-data:/data:ro \
      -v "$PWD/backups:/backup" \
      alpine tar czf "/backup/$(basename "$out")" -C /data .
    echo "backup written: $out"
    ;;
  *)
    echo "usage: $0 {up|down|logs [service]|pull|ps|backup}"
    exit 1
    ;;
esac
