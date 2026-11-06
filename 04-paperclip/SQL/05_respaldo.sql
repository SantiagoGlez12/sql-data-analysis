-- Actividad Paperclip - Paso 5: respaldo completo de la base Paperclip.
-- Archivo resultante DENTRO del contenedor:
-- /var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak
USE [master];
GO
BACKUP DATABASE [Paperclip]
TO DISK = N'/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak'
WITH INIT, FORMAT, CHECKSUM, STATS = 10;
GO

-- Validar que SQL Server puede leer el respaldo antes de borrar la base.
RESTORE VERIFYONLY
FROM DISK = N'/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak'
WITH CHECKSUM;
GO
