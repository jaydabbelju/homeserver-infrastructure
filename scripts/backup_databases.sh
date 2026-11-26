#!/bin/bash

DATUM=$(date +%Y-%m-%d)
ZIEL="/mnt/raid/nas/Backups/db_backup_$DATUM.tar.gz"

# Datenbank-Container werden vor Backup gestoppt
docker stop paperless_db immich_postgres vaultwarden gitea

echo "Datenbank-Container werden gestoppt."

tar -czf "$ZIEL" \
  /home/homeserver/vaultwarden_data \
  /home/homeserver/paperless_db \
  /home/homeserver/gitea_data \
  /home/homeserver/immich_db \
  /home/homeserver/infrastructure

# Datenbank-Container werden nach Backup-Erstellung gestartet
docker start paperless_db immich_postgres vaultwarden gitea

echo "Datenbank-Container werden gestartet."

# Backups die älter sind als 14 Tage werden gelöscht.
find /mnt/raid/nas/Backups/ -name "db_backup_*.tar.gz" -mtime +14 -delete

echo "Backup erfolgreich erstellt: $ZIEL"
