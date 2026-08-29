# homelab-compose

Reproduzierbarer Self-Hosting-Basis-Stack mit Docker Compose: Monitoring,
Log-Viewer, automatische Updates und eine statische Startseite — ein `up` und läuft.

## Problem

Ein Homelab wächst schnell zu einem Zoo aus handgestarteten Containern, den
niemand mehr reproduzieren kann. Dieser Stack ist die versionierte Basis:
ein Repo klonen, `.env` anlegen, `./manage.sh up` — fertig.

## Architektur

```
                ┌─────────────────────────────────────────┐
                │            Docker Netz: homelab          │
   :8080 ──────▶│  landing      (nginx, statische Seite)   │
   :3001 ──────▶│  uptime-kuma  (Monitoring + Alerts)      │
   :8888 ──────▶│  dozzle       (Live-Logs aller Container)│
                │  watchtower   (autom. Image-Updates 04:00)│
                └─────────────────────────────────────────┘
```

| Dienst      | Zweck                                          | Port (Default) |
|-------------|------------------------------------------------|----------------|
| landing     | Statische Übersichtsseite (nginx)              | 8080           |
| uptime-kuma | Uptime-Monitoring mit Web-UI und Alerting      | 3001           |
| dozzle      | Live-Log-Viewer für alle Container (read-only) | 8888           |
| watchtower  | Zieht täglich um 04:00 neue Images, räumt auf  | —              |

Uptime-Kuma und Dozzle binden bewusst nur auf `127.0.0.1` (Dozzle zeigt alle
Container-Logs ohne Auth). Wer sie im LAN oder öffentlich erreichbar machen
will, stellt einen eigenen Reverse-Proxy mit Authentifizierung (z.B. nginx +
Basic Auth oder Authelia) davor, statt die `127.0.0.1:`-Bindung zu entfernen.

## Stack

Docker Compose v2, Images: `louislam/uptime-kuma`, `amir20/dozzle`,
`containrrr/watchtower`, `nginx:alpine`.

## Setup & Start

```bash
git clone <repo-url> homelab-compose
cd homelab-compose
cp .env.example .env      # Ports anpassen falls belegt
./manage.sh up            # Stack starten
./manage.sh ps            # Status
./manage.sh logs dozzle   # Logs eines Dienstes folgen
```

## Backup

`./manage.sh backup` sichert das Uptime-Kuma-Datenvolume als
`backups/uptime-kuma-<datum>.tar.gz` (Monitore, Historie, Einstellungen).
`backups/` und `.env` sind bewusst nicht im Git.

## Hinweise

- Dozzle und Watchtower brauchen den Docker-Socket; Dozzle bekommt ihn **read-only**.
- Neue eigene Dienste: Service-Block ergänzen, ins `homelab`-Netz hängen,
  Port in `.env.example` dokumentieren.

## Screenshot

_(Screenshot folgt)_
