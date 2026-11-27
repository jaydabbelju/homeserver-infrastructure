#!/bin/bash

echo "============================================================"
echo "  HOMESERVER STATUS  |  $(date '+%d.%m.%Y %H:%M Uhr')"
echo "============================================================"

# 1. System & Speicher
UPTIME=$(uptime -p | sed 's/up //')
RAM_USED=$(free -h | awk '/^(Mem|Speicher):/ {print $3 " / " $2}')
DISK_SSD=$(df -h / | awk 'NR==2 {print $5 " belegt (" $4 " frei)"}')
DISK_RAID=$(df -h /mnt/raid | awk 'NR==2 {print $5 " belegt (" $4 " frei)"}')
echo "System:    Uptime: $UPTIME | RAM: $RAM_USED"
echo "Speicher:  SSD: $DISK_SSD | RAID: $DISK_RAID"

# 2. RAID-1 Gesundheit
RAID_STATE=$(grep -E "active|degraded" /proc/mdstat | awk '{print $3, $4}')
echo "RAID 1:    Status: ${RAID_STATE:-Pruefung erforderlich}"

# 3. Backup-Check
LAST_BACKUP=$(ls -1t /mnt/raid/nas/Backups/db_backup_*.tar.gz 2>/dev/null | head -n 1)
if [ -n "$LAST_BACKUP" ]; then
    B_NAME=$(basename "$LAST_BACKUP")
    B_SIZE=$(du -h "$LAST_BACKUP" | cut -f1)
    echo "Backup:    Letztes: $B_NAME ($B_SIZE)"
else
    echo "Backup:    WARNUNG - Kein Backup gefunden!"
fi

# 4. Sicherheit & Updates
F2B_BANNED=$(fail2ban-client status sshd 2>/dev/null | grep "Currently banned" | awk '{print $4}')
UPDATES=$(apt-get -s upgrade 2>/dev/null | grep -P '^\d+ upgraded' | cut -d" " -f1)
LAST_AUTO_UPD=$(grep -E "Packages that will be upgraded:" /var/log/unattended-upgrades/unattended-upgrades.log 2>/dev/null | tail -n 1 | cut -d":" -f2-)
echo "Security:  Fail2ban gebannt: ${F2B_BANNED:-0} IPs | Offene Updates: ${UPDATES:-0}"
if [ -n "$LAST_AUTO_UPD" ]; then
    echo "Auto-Upd:  Zuletzt aktualisiert:$LAST_AUTO_UPD"
fi

# 5. Samba & Docker
SAMBA_USERS=$(smbstatus -b 2>/dev/null | grep -E "^[0-9]+" | wc -l)
DOCKER_UP=$(docker ps --format '{{.Names}}' | wc -l)
DOCKER_ALL=$(docker ps -a --format '{{.Names}}' | wc -l)
DOCKER_STOPPED=$(docker ps -a --filter "status=exited" --format '{{.Names}}' | tr '\n' ' ')
echo "Samba:     Aktive Verbindungen: $SAMBA_USERS"
echo "Docker:    $DOCKER_UP von $DOCKER_ALL Containern aktiv"
if [ -n "$DOCKER_STOPPED" ]; then
    echo "Gestoppt:  $DOCKER_STOPPED"
fi
echo "============================================================"
