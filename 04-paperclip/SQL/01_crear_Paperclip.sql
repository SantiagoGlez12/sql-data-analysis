-- Actividad Paperclip - Paso 1: crear base de datos, asignar propietario y comprobar ruta.
-- EJECUTAR SOLO DESPUES DE CONFIGURAR LAS CARPETAS EN EL CONTENEDOR (script Mac/00...).
-- Conectarse a SQL Server con una cuenta que pueda CREATE DATABASE y ALTER AUTHORIZATION.
USE [master];
GO

-- Crear Paperclip con archivos fisicos en el directorio solicitado.
-- Los nombres logicos Paperclip y Paperclip_log se utilizaran en la restauracion.
CREATE DATABASE [Paperclip]
ON PRIMARY (
    NAME = N'Paperclip',
    FILENAME = N'/var/opt/mssql/data/BasesDeDatos/Paperclip.mdf'
)
LOG ON (
    NAME = N'Paperclip_log',
    FILENAME = N'/var/opt/mssql/data/BasesDeDatos/Paperclip_log.ldf'
);
GO

-- Asignar la propiedad al login con el que te conectaste al servidor.
DECLARE @Propietario SYSNAME = ORIGINAL_LOGIN();
DECLARE @SQL NVARCHAR(MAX) =
    N'ALTER AUTHORIZATION ON DATABASE::[Paperclip] TO ' + QUOTENAME(@Propietario) + N';';
EXEC sys.sp_executesql @SQL;
GO

-- Comprobar el propietario y las rutas reales de los archivos creados.
SELECT DB_NAME(database_id) AS BaseDeDatos,
       SUSER_SNAME(owner_sid) AS Propietario
FROM sys.databases
WHERE name = N'Paperclip';

SELECT name AS NombreLogico, physical_name AS RutaFisica
FROM sys.master_files
WHERE database_id = DB_ID(N'Paperclip');
GO
