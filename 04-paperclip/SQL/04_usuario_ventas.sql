-- Actividad Paperclip - Paso 4: crear LOGIN de servidor y USER de base de datos.
-- OBLIGATORIO: reemplaza la contrasena del ejemplo antes de ejecutar este archivo.
USE [master];
GO
CREATE LOGIN [UsuarioVentas]
WITH PASSWORD = 'REEMPLAZA_ESTA_CLAVE_2026!A7',
     CHECK_POLICY = ON,
     DEFAULT_DATABASE = [Paperclip];
GO

USE [Paperclip];
GO
CREATE USER [UsuarioVentas] FOR LOGIN [UsuarioVentas];
GO

-- Dar acceso de lectura unicamente sobre el esquema Ventas.
GRANT CONNECT TO [UsuarioVentas];
GRANT SELECT ON SCHEMA::[Ventas] TO [UsuarioVentas];

-- Explicitamente denegar lectura sobre RH y escritura en Ventas.
DENY SELECT ON SCHEMA::[RH] TO [UsuarioVentas];
DENY INSERT, UPDATE, DELETE ON SCHEMA::[Ventas] TO [UsuarioVentas];
GO

-- Verificar los permisos sin alterar tablas ni producir errores intencionales.
EXECUTE AS USER = N'UsuarioVentas';
SELECT TOP (5) IDCliente FROM [Ventas].[Clientes] ORDER BY IDCliente;
SELECT
    HAS_PERMS_BY_NAME(N'Ventas.Clientes', N'OBJECT', N'SELECT') AS PuedeLeerVentas,
    HAS_PERMS_BY_NAME(N'Ventas.Clientes', N'OBJECT', N'INSERT') AS PuedeInsertarVentas,
    HAS_PERMS_BY_NAME(N'RH.Empleados', N'OBJECT', N'SELECT') AS PuedeLeerRH;
REVERT;
GO
-- Resultados esperados de HAS_PERMS_BY_NAME: 1, 0 y 0.
-- Para probar el login de verdad, conecta desde VS Code con UsuarioVentas y tu clave.
