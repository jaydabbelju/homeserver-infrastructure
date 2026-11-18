DATUM=$(date +%Y-%m-%d)
ZIEL="/mnt/raid/nas/Backups/db_backup_$DATUM.tar.gz"

#Datenbank und kritische Container
docker stop paperless_db immich_postgres vaultwarden gitea

echo "Docker-Container werden gestoppt"

tar -czf "$ZIEL" \
  /home/homeserver/vaultwarden_data \
  /home/homeserver/paperless_db \
  /home/homeserver/gitea_data \
  /home/homeserver/immich_db \
  /home/homeserver/infrastructure

#Datenbank und kritische Container
docker start paperless_db immich_postgres vaultwarden gitea

echo "Docker-Container werden gestartet."

find /mnt/raid/nas/Backups/ -name "db_backup_*.tar.gz" -mtime +14 -delete

echo "Backup erfolgreich erstellt: $ZIEL"
