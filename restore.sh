#!/bin/bash

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo "Ús: $0 <arxiu_backup.tar.gz>"
    exit 1
fi

echo "[INFO] Descomprimint còpia..."
tar -xzf "$BACKUP_FILE" -C /tmp

# Cercar el directori descomprimit
RESTORE_DIR=$(find /tmp -maxdepth 1 -type d -name "webserver_*" | head -n 1)

echo "[INFO] Instal·lant Apache..."
apt update
apt install -y apache2

echo "[INFO] Restauració de configuració..."
cp -a "$RESTORE_DIR"/apache2_config/* /etc/apache2/

echo "[INFO] Restauració de contingut web..."
cp -a "$RESTORE_DIR"/www/* /var/www/

echo "[INFO] Restauració de paquets addicionals..."
dpkg --set-selections < "$RESTORE_DIR"/packages.list
apt-get dselect-upgrade -y

echo "[INFO] Reiniciant servei HTTP..."
systemctl restart apache2

echo "[OK] Restauració completada."
