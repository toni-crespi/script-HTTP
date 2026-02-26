#!/bin/bash

# Directori de destí
BACKUP_DIR="/backup/webserver_$(date +%Y%m%d_%H%M)"

mkdir -p "$BACKUP_DIR"
echo "[INFO] Creant còpia de seguretat a $BACKUP_DIR"

# 1. Configuració d'Apache
echo "[INFO] Copiant configuració d'Apache..."
cp -a /etc/apache2 "$BACKUP_DIR"/apache2_config

# 2. Contingut web
echo "[INFO] Copiant DocumentRoot..."
cp -a /var/www "$BACKUP_DIR"/www

# 3. Llista de paquets instal·lats
echo "[INFO] Guardant llista de paquets..."
dpkg --get-selections > "$BACKUP_DIR"/packages.list

# 4. Compressió final
echo "[INFO] Comprimint còpia..."
tar -czf "$BACKUP_DIR".tar.gz -C /backup $(basename "$BACKUP_DIR")

echo "[OK] Còpia de seguretat completada: $BACKUP_DIR.tar.gz"
