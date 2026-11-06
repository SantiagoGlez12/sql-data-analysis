#!/usr/bin/env bash
# Actividad Paperclip - prepara carpetas, CSV y directorios por defecto en SQL Server Docker.
# Uso: bash Mac/00_configurar_mac_docker.sh NOMBRE_DEL_CONTENEDOR
# Modifica la configuracion del motor y reinicia el contenedor; no elimina bases existentes.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo 'Uso: bash Mac/00_configurar_mac_docker.sh NOMBRE_DEL_CONTENEDOR' >&2
  echo 'Encuentra el nombre con: docker ps --format "{{.Names}}"' >&2
  exit 1
fi
CONTENEDOR="$1"
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CARPETA_MAC="$HOME/BasesDeDatos"

# Comprobar que el contenedor existe antes de hacer cambios.
docker inspect "$CONTENEDOR" >/dev/null
mkdir -p "$CARPETA_MAC/CSV" "$CARPETA_MAC/Respaldos"
cp "$BASE"/CSV/*.csv "$CARPETA_MAC/CSV/"

# Crear rutas dentro del contenedor, dar acceso al usuario mssql y cambiar el valor por defecto.
docker exec -u 0 "$CONTENEDOR" /bin/bash -c '
set -e
RUTA=/var/opt/mssql/data/BasesDeDatos
mkdir -p "$RUTA/CSV" "$RUTA/Respaldos"
chown -R 10001:0 "$RUTA"
chmod -R u+rwX,g+rwX "$RUTA"
/opt/mssql/bin/mssql-conf set filelocation.defaultdatadir "$RUTA"
/opt/mssql/bin/mssql-conf set filelocation.defaultlogdir "$RUTA"
/opt/mssql/bin/mssql-conf set filelocation.defaultbackupdir "$RUTA/Respaldos"
'

for ARCHIVO in "$BASE"/CSV/*.csv; do
    docker cp "$ARCHIVO" "$CONTENEDOR:/var/opt/mssql/data/BasesDeDatos/CSV/$(basename "$ARCHIVO")"
done

docker exec -u 0 "$CONTENEDOR" /bin/bash -c '
RUTA=/var/opt/mssql/data/BasesDeDatos
chown -R 10001:0 "$RUTA"
chmod -R u+rwX,g+rwX "$RUTA"
'

echo 'Reiniciando el contenedor para aplicar la ubicacion por defecto...'
docker restart "$CONTENEDOR"
echo 'Configuracion finalizada. Verificar que SQL Server reinicie y despues ejecutar 01_crear_Paperclip.sql.'
echo "CSV locales: $CARPETA_MAC/CSV"
echo 'Ruta de trabajo en SQL Server: /var/opt/mssql/data/BasesDeDatos'
