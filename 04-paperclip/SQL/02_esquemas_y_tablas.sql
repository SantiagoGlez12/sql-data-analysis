-- Actividad Paperclip - Paso 2: crear esquemas RH y Ventas y las cinco tablas.
-- Se respeta la estructura de la captura: solo la columna INT NOT NULL indicada.
USE [Paperclip];
GO

CREATE SCHEMA [RH] AUTHORIZATION [dbo];
GO
CREATE SCHEMA [Ventas] AUTHORIZATION [dbo];
GO

CREATE TABLE [RH].[Departamentos] (
    IDDepartamento INT NOT NULL CONSTRAINT PK_Departamentos PRIMARY KEY
);
GO
CREATE TABLE [RH].[Empleados] (
    IDEmpleado INT NOT NULL CONSTRAINT PK_Empleados PRIMARY KEY
);
GO
CREATE TABLE [Ventas].[Clientes] (
    IDCliente INT NOT NULL CONSTRAINT PK_Clientes PRIMARY KEY
);
GO
CREATE TABLE [Ventas].[Ordenes] (
    IDOrden INT NOT NULL CONSTRAINT PK_Ordenes PRIMARY KEY
);
GO
CREATE TABLE [Ventas].[Productos] (
    IDProducto INT NOT NULL CONSTRAINT PK_Productos PRIMARY KEY
);
GO

-- Verificar esquemas, tablas y columnas generadas.
SELECT s.name AS Esquema, t.name AS Tabla, c.name AS Columna,
       TYPE_NAME(c.user_type_id) AS TipoDeDato, c.is_nullable AS PermiteNulos
FROM sys.tables t
INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
INNER JOIN sys.columns c ON c.object_id = t.object_id
WHERE s.name IN (N'RH', N'Ventas')
ORDER BY s.name, t.name, c.column_id;
GO
