-- Actividad Paperclip - Paso 3: importar datos dummy desde los cinco archivos CSV.
-- PRERREQUISITO: copiar los CSV a /var/opt/mssql/data/BasesDeDatos/CSV/.
-- Cada archivo tiene cabecera y terminador de linea LF (0x0a).
-- Ejecutar solo una vez: volver a importar produce claves primarias duplicadas.
USE [Paperclip];
GO

BULK INSERT [RH].[Departamentos]
FROM '/var/opt/mssql/data/BasesDeDatos/CSV/Departamentos.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

BULK INSERT [RH].[Empleados]
FROM '/var/opt/mssql/data/BasesDeDatos/CSV/Empleados.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

BULK INSERT [Ventas].[Clientes]
FROM '/var/opt/mssql/data/BasesDeDatos/CSV/Clientes.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

BULK INSERT [Ventas].[Ordenes]
FROM '/var/opt/mssql/data/BasesDeDatos/CSV/Ordenes.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

BULK INSERT [Ventas].[Productos]
FROM '/var/opt/mssql/data/BasesDeDatos/CSV/Productos.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

-- Comprobar inmediatamente los 1,810 registros esperados.
SELECT N'RH.Departamentos' AS Tabla, COUNT(*) AS Registros, 10 AS Esperados FROM [RH].[Departamentos]
UNION ALL SELECT N'RH.Empleados', COUNT(*), 100 FROM [RH].[Empleados]
UNION ALL SELECT N'Ventas.Clientes', COUNT(*), 200 FROM [Ventas].[Clientes]
UNION ALL SELECT N'Ventas.Ordenes', COUNT(*), 500 FROM [Ventas].[Ordenes]
UNION ALL SELECT N'Ventas.Productos', COUNT(*), 1000 FROM [Ventas].[Productos];
GO
