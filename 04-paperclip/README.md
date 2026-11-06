# Paperclip — SQL Server Administration Lab

A standalone practice database with `RH` and `Ventas` schemas. Five CSVs contain integer IDs only; they are not employee/customer profiles.

| Table | Source rows |
| --- | ---: |
| RH.Departamentos | 10 |
| RH.Empleados | 100 |
| Ventas.Clientes | 200 |
| Ventas.Ordenes | 500 |
| Ventas.Productos | 1,000 |

## Original package and order

The `SQL/`, `CSV/`, and `Mac/` paths retain their original names so the scripts' relative references keep working. Read [LEEME.md](LEEME.md) for the original Spanish instructions.

1. Review the existing Docker SQL Server environment and the original `Mac/00_configurar_mac_docker.sh` helper. That helper changes engine default paths and restarts the selected container.
2. Run SQL files 01 and 02 to create Paperclip, its schemas and tables.
3. Review the container-visible file paths and platform options before running 03 to import the CSVs. Its `CODEPAGE = '65001'` option is platform-dependent and has not been validated against a Linux engine here.
4. Replace the explicit example password in 04 before creating `UsuarioVentas`. This account is granted read access to Ventas, denied read access to RH, and denied data changes in Ventas.
5. Use 05 to create and check a backup; copy the backup out using the second Mac helper.
6. File 06 deliberately drops and restores **Paperclip**. Use it only in the disposable exercise environment after verifying and copying the backup.
7. File 07 checks the restored schema, counts, users and file paths.

The original `.bak` is not included; generate it from your own lab instance. The supplied shell helpers are preserved, not automatically executed. Shell syntax and CSV counts were checked; SQL execution and a full restore were not performed during this migration.
