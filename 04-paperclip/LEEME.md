# Actividad Paperclip – SQL Server en Docker (Mac Apple Silicon)

Este paquete incluye los 5 CSV y los scripts SQL en orden de ejecución.

**Importante:** No contiene un archivo `.bak` generado, porque el respaldo debe crearse en tu propio servidor SQL Server mediante el paso 05. El script `Mac/07_copiar_bak_a_mac.sh` lo copiará después a tu Mac.

## Estructura solicitada (idéntica a lo visible en la captura)

| Tabla | Única columna visible | Registros CSV |
|---|---|---:|
| RH.Departamentos | IDDepartamento INT NOT NULL | 10 |
| RH.Empleados | IDEmpleado INT NOT NULL | 100 |
| Ventas.Clientes | IDCliente INT NOT NULL | 200 |
| Ventas.Ordenes | IDOrden INT NOT NULL | 500 |
| Ventas.Productos | IDProducto INT NOT NULL | 1000 |

**La imagen de la tarea solo muestra estas columnas identificadoras.** No añadimos nombres, fechas ni relaciones no especificadas. Las columnas ID llevan llave primaria para evitar duplicados.

## Antes de ejecutar

1. Tener SQL Server (no MySQL/PostgreSQL) funcionando en Docker y disponible desde VS Code.
2. Abrir Terminal en Mac y buscar el nombre del contenedor:

   `docker ps --format '{{.Names}}'`

3. Extraer este ZIP. Desde la carpeta donde lo descomprimiste, ejecutar:

   `bash Mac/00_configurar_mac_docker.sh NOMBRE_DEL_CONTENEDOR`

   Cambiar `NOMBRE_DEL_CONTENEDOR` por el nombre real, sin comillas especiales.

Este paso crea en el contenedor las carpetas:

```
/var/opt/mssql/data/BasesDeDatos/
    CSV/
        Departamentos.csv
        Empleados.csv
        Clientes.csv
        Ordenes.csv
        Productos.csv
    Respaldos/
```

Además crea `$HOME/BasesDeDatos/CSV` y `$HOME/BasesDeDatos/Respaldos` en el Mac, cambia las rutas predeterminadas de datos, log y backups mediante `mssql-conf` y **reinicia el contenedor** (no lo elimina). La ruta `/var/opt/mssql/data/BasesDeDatos` debe ser accesible para el usuario mssql. Si el contenedor utiliza una imagen distinta a la oficial de SQL Server, comprueba que `mssql-conf` esté disponible.

**Precaución sobre almacenamiento:** El folder `$HOME/BasesDeDatos` del Mac y la ruta dentro del contenedor NO son automáticamente la misma carpeta. Si tu contenedor ya tiene un bind mount de `/var/opt/mssql/data` a una carpeta del Mac, los MDF/LDF aparecerán también allí; puedes comprobarlo con:

`docker inspect NOMBRE_DEL_CONTENEDOR --format '{{range .Mounts}}{{println .Source "->" .Destination}}{{end}}'`

Si usa un volumen Docker, los archivos del motor estarán dentro de ese volumen, no directamente en `$HOME/BasesDeDatos`. NO elimines ni recrees el contenedor para cambiar esto sin preservar tus bases previas. El paso 07 copia el `.bak` al Mac de manera segura en ambos casos.

## Ejecutar en VS Code

Abrir SQL Server desde VS Code con una conexión con permisos para crear bases y logins (normalmente `sa`). **Ejecuta cada archivo por separado y en este orden**, no todos de golpe:

1. `SQL/01_crear_Paperclip.sql` – Crea Paperclip, la asigna al login conectado y consulta propietario/rutas.
2. `SQL/02_esquemas_y_tablas.sql` – Crea RH/Ventas y las cinco tablas; comprueba la estructura.
3. `SQL/03_importar_CSV.sql` – Importa 10, 100, 200, 500 y 1000 filas; muestra los conteos.
4. `SQL/04_usuario_ventas.sql` – **Cambia antes la contraseña de ejemplo**. Crea el login, el usuario y prueba los permisos; no le da escritura ni lectura de RH.
5. `SQL/05_respaldo.sql` – Crea y verifica `/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak`.
6. **Antes de borrar la base, copia el respaldo a tu Mac** con:

   `bash Mac/07_copiar_bak_a_mac.sh NOMBRE_DEL_CONTENEDOR`

7. `SQL/06_eliminar_y_restaurar.sql` – Comprueba el respaldo, borra Paperclip y la restaura en el mismo directorio. **Paso destructivo: ejecuta solo con el .bak verificado y copiado.**
8. `SQL/07_verificar_restauracion.sql` – Comprueba tablas, 1,810 filas, rutas y usuario restaurado.

## Prueba adicional de UsuarioVentas

En VS Code crea una segunda conexión con:

- Usuario: `UsuarioVentas`
- Contraseña: la que configuraste en el archivo 04.
- Base de datos: `Paperclip`

Esta consulta debe funcionar:

`SELECT TOP (5) * FROM Ventas.Clientes;`

Esta otra debe dar error de permisos:

`SELECT TOP (5) * FROM RH.Empleados;`

También debe fallar `INSERT` contra cualquier tabla de `Ventas`.

## Capturas sugeridas para la entrega

- `sys.master_files`: los archivos `.mdf` y `.ldf` en `BasesDeDatos`.
- Tablas bajo los esquemas `RH` y `Ventas`.
- Los conteos de registros en el resultado de 03 o 07.
- Permisos de `UsuarioVentas` y una consulta permitida/denegada.
- `.bak` en tu Mac bajo `~/BasesDeDatos/Respaldos/`.
- Conteos y tablas restauradas tras ejecutar 06 y 07.

## Notas

- `GO` es separador de lotes de SQL Server y permite crear objetos correctamente. Si la extensión SQL de VS Code no reconoce `GO`, asegúrate de que usas la extensión **SQL Server (mssql)**.
- Los scripts de creación/importación no se deben ejecutar dos veces sin limpiar los objetos/datos, pues ya existen o contienen las mismas claves primarias.
- El respaldo `.bak` no se puede fabricar sin el servidor: debe provenir de `BACKUP DATABASE` ejecutado sobre la base real.
- Para importar con `BULK INSERT`, la ruta es la que ve SQL Server **dentro de Docker**, no la ruta de Finder en macOS.
