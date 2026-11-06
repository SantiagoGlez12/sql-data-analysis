#!/usr/bin/env bash
# Copia Paperclip.bak del contenedor al Mac. Ejecutar DESPUES de SQL/05_respaldo.sql.
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo 'Uso: bash Mac/07_copiar_bak_a_mac.sh NOMBRE_DEL_CONTENEDOR' >&2
  exit 1
fi
CONTENEDOR="$1"
DESTINO="$HOME/BasesDeDatos/Respaldos/Paperclip.bak"
mkdir -p "$(dirname "$DESTINO")"
docker cp "$CONTENEDOR:/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak" "$DESTINO"
test -s "$DESTINO" || { echo 'ERROR: respaldo inexistente o vacio' >&2; exit 1; }
echo "Respaldo guardado en: $DESTINO"
ls -lh "$DESTINO"
