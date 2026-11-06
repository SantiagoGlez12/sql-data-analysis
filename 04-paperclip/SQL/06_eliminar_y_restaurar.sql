-- Actividad Paperclip - Paso 6: eliminar y restaurar Paperclip desde su .bak.
-- ATENCION: EJECUTA SOLO DESPUES DE TERMINAR Y VERIFICAR EL RESPALDO DEL PASO 5.
-- Recomendacion: tambien guardar una copia local usando Mac/07_copiar_bak_a_mac.sh.
-- No elimina otras bases de datos.
USE [master];
GO
BEGIN TRY
    -- Si este comando falla, no se borra la base de datos.
    RESTORE VERIFYONLY
    FROM DISK = N'/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak'
    WITH CHECKSUM;

    IF DB_ID(N'Paperclip') IS NOT NULL
    BEGIN
        ALTER DATABASE [Paperclip] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE [Paperclip];
    END;

    RESTORE DATABASE [Paperclip]
    FROM DISK = N'/var/opt/mssql/data/BasesDeDatos/Respaldos/Paperclip.bak'
    WITH MOVE N'Paperclip'
         TO N'/var/opt/mssql/data/BasesDeDatos/Paperclip.mdf',
         MOVE N'Paperclip_log'
         TO N'/var/opt/mssql/data/BasesDeDatos/Paperclip_log.ldf',
         RECOVERY,
         STATS = 10;
END TRY
BEGIN CATCH
    -- Si el error sucede antes del DROP, devolver acceso multiusuario.
    IF DB_ID(N'Paperclip') IS NOT NULL
    BEGIN
        BEGIN TRY
            ALTER DATABASE [Paperclip] SET MULTI_USER WITH ROLLBACK IMMEDIATE;
        END TRY
        BEGIN CATCH
        END CATCH;
    END;
    THROW;
END CATCH;
GO
