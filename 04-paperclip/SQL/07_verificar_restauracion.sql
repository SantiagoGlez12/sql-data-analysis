-- Actividad Paperclip - Paso 7: verificar la base restaurada, tablas, datos, usuario y rutas.
USE [Paperclip];
GO

SELECT N'RH.Departamentos' AS Tabla, COUNT(*) AS Registros, 10 AS Esperados FROM [RH].[Departamentos]
UNION ALL SELECT N'RH.Empleados', COUNT(*), 100 FROM [RH].[Empleados]
UNION ALL SELECT N'Ventas.Clientes', COUNT(*), 200 FROM [Ventas].[Clientes]
UNION ALL SELECT N'Ventas.Ordenes', COUNT(*), 500 FROM [Ventas].[Ordenes]
UNION ALL SELECT N'Ventas.Productos', COUNT(*), 1000 FROM [Ventas].[Productos];
GO

SELECT s.name AS Esquema, t.name AS Tabla
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name IN (N'RH', N'Ventas')
ORDER BY s.name, t.name;
GO

SELECT name AS ArchivoLogico, physical_name AS RutaFisica
FROM sys.database_files;
GO

SELECT name AS Usuario, type_desc AS Tipo
FROM sys.database_principals
WHERE name = N'UsuarioVentas';
GO

-- Verificar tambien que el login de servidor siga existiendo.
USE [master];
GO
SELECT name AS LoginServidor, type_desc
FROM sys.server_principals
WHERE name = N'UsuarioVentas';
GO
