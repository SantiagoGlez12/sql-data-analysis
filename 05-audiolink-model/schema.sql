/* ACTIVIDAD M14 - Modelo relacional AudioLink Eventos - Santiago Gonzalez*/
CREATE DATABASE AudioLink;
GO
USE AudioLink;
GO

CREATE TABLE dbo.Cliente (
    IdCliente INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(120) NOT NULL,
    Correo NVARCHAR(254) NOT NULL,
    Telefono NVARCHAR(20) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (IdCliente),
    CONSTRAINT UQ_Cliente_Correo UNIQUE (Correo)
);
GO

CREATE TABLE dbo.Sede (
    IdSede INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(120) NOT NULL,
    Direccion NVARCHAR(220) NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    Capacidad INT NOT NULL,
    CONSTRAINT PK_Sede PRIMARY KEY (IdSede),
    CONSTRAINT CHK_Sede_Capacidad CHECK (Capacidad > 0)
);
GO

CREATE TABLE dbo.CategoriaEquipo (
    IdCategoria INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(80) NOT NULL,
    CONSTRAINT PK_CategoriaEquipo PRIMARY KEY (IdCategoria),
    CONSTRAINT UQ_CategoriaEquipo_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.Equipo (
    IdEquipo INT IDENTITY(1,1) NOT NULL,
    IdCategoria INT NOT NULL,
    Codigo VARCHAR(30) NOT NULL,
    Nombre NVARCHAR(120) NOT NULL,
    PrecioRenta DECIMAL(12,2) NOT NULL,
    StockTotal INT NOT NULL,
    CONSTRAINT PK_Equipo PRIMARY KEY (IdEquipo),
    CONSTRAINT FK_Equipo_Categoria FOREIGN KEY (IdCategoria)
        REFERENCES dbo.CategoriaEquipo (IdCategoria),
    CONSTRAINT UQ_Equipo_Codigo UNIQUE (Codigo),
    CONSTRAINT CHK_Equipo_Precio CHECK (PrecioRenta > 0),
    CONSTRAINT CHK_Equipo_Stock CHECK (StockTotal >= 0)
);
GO

CREATE TABLE dbo.Tecnico (
    IdTecnico INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(120) NOT NULL,
    Correo NVARCHAR(254) NOT NULL,
    Telefono NVARCHAR(20) NULL,
    CONSTRAINT PK_Tecnico PRIMARY KEY (IdTecnico),
    CONSTRAINT UQ_Tecnico_Correo UNIQUE (Correo)
);
GO

CREATE TABLE dbo.Evento (
    IdEvento INT IDENTITY(1,1) NOT NULL,
    IdCliente INT NOT NULL,
    IdSede INT NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    FechaInicio DATETIME2(0) NOT NULL,
    FechaFin DATETIME2(0) NOT NULL,
    Estado VARCHAR(15) NOT NULL CONSTRAINT DF_Evento_Estado DEFAULT ('Planeado'),
    CONSTRAINT PK_Evento PRIMARY KEY (IdEvento),
    CONSTRAINT FK_Evento_Cliente FOREIGN KEY (IdCliente)
        REFERENCES dbo.Cliente (IdCliente),
    CONSTRAINT FK_Evento_Sede FOREIGN KEY (IdSede)
        REFERENCES dbo.Sede (IdSede),
    CONSTRAINT CHK_Evento_Fechas CHECK (FechaFin > FechaInicio),
    CONSTRAINT CHK_Evento_Estado CHECK
        (Estado IN ('Planeado','Confirmado','Finalizado','Cancelado'))
);
GO

CREATE TABLE dbo.DetalleEquipoEvento (
    IdEvento INT NOT NULL,
    IdEquipo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioPactado DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_DetalleEquipoEvento PRIMARY KEY (IdEvento, IdEquipo),
    CONSTRAINT FK_Detalle_Evento FOREIGN KEY (IdEvento)
        REFERENCES dbo.Evento (IdEvento),
    CONSTRAINT FK_Detalle_Equipo FOREIGN KEY (IdEquipo)
        REFERENCES dbo.Equipo (IdEquipo),
    CONSTRAINT CHK_Detalle_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CHK_Detalle_Precio CHECK (PrecioPactado > 0)
);
GO

CREATE TABLE dbo.AsignacionTecnico (
    IdEvento INT NOT NULL,
    IdTecnico INT NOT NULL,
    Funcion NVARCHAR(80) NOT NULL,
    CONSTRAINT PK_AsignacionTecnico PRIMARY KEY (IdEvento, IdTecnico),
    CONSTRAINT FK_Asignacion_Evento FOREIGN KEY (IdEvento)
        REFERENCES dbo.Evento (IdEvento),
    CONSTRAINT FK_Asignacion_Tecnico FOREIGN KEY (IdTecnico)
        REFERENCES dbo.Tecnico (IdTecnico)
);
GO

-- Consultas de comprobación de estructura
SELECT t.name AS Tabla, s.name AS Esquema
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo'
ORDER BY t.name;

SELECT fk.name AS Relacion, OBJECT_NAME(fk.parent_object_id) AS TablaHija,
       OBJECT_NAME(fk.referenced_object_id) AS TablaPadre
FROM sys.foreign_keys fk
ORDER BY TablaHija, TablaPadre;

-- Ejemplo de reporte: coste pactado de equipos por evento
-- (se obtiene por consulta para evitar guardar un total calculado)
SELECT e.IdEvento, e.Nombre AS NombreEvento,
       SUM(d.Cantidad * d.PrecioPactado) AS TotalEquipoPactado
FROM dbo.Evento e
INNER JOIN dbo.DetalleEquipoEvento d ON e.IdEvento = d.IdEvento
GROUP BY e.IdEvento, e.Nombre;
