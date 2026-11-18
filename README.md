# Homeserver Infrastruktur (Debian 13 + Docker)

## Hardware
- CPU: Intel
- RAM: 32 GB DDR3
- Storage: 240 GB SSD + 465 GB Software-RAID 1 (/mnt/raid)

## Aktive Services
- Reverse Proxy & SSL: Nginx Proxy Manager + DuckDNS
- Security: Fail2ban + WireGuard VPN
- Passwörter: Vaultwarden
- Fotos & Medien: Immich
- Dokumenten-Management: Paperless-ngx
- Lokale KI: Ollama (huihui_ai/llama3.2-abliterate:3b) + Open WebUI 
- Git & DevOps: Gitea (Mirror aktiv)
- Pi-hole ("Permit all origins" + Fritz!Box-DNS auf.69)

## Weiteres
- NAS über VPN aus anderen Netzen erreichbar.
- Ein Skript sorgt über /etc/cron.daily dafür, dass die Datenbank-Container während des Backups gestoppt werden um Fehler bei und durch die Erstellung zu vermeiden. Die Container selbst werden als tar.gz Dateien auf meinem NAS abgespeichert.
