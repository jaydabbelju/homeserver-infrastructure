DATUM=$(date +%Y-%m-%d)
ZIEL="/mnt/raid/nas/Backups/db_backup_$DATUM.tar.gz"


tar -czf "$ZIEL" \
  /home/homeserver/vaultwarden_data \
  /home/homeserver/paperless_db \
  /home/homeserver/gitea_data \
  /home/homeserver/immich_db \
  /home/homeserver/infrastructure

find /mnt/raid/nas/Backups/ -name "db_backup_*.tar.gz" -mtime +14 -delete

echo "Backup erfolgreich erstellt: $ZIEL"
