--Tarea  - Santiago Gonzalez

--Ej 1. Creación y consulta de la vista Production.vCostoProductoSimple para mostrar el identificador, nombre y precio de lista de los productos.
CREATE OR ALTER VIEW Production.vCostoProductoSimple AS
SELECT
    prod.ProductID,
    prod.Name AS NombreProducto,
    prod.ListPrice AS PrecioLista
FROM Production.Product prod;
GO
-- Consultar los resultados de la vista
SELECT *
FROM Production.vCostoProductoSimple
ORDER BY NombreProducto ASC;
GO

--Ej 2. Creación y consulta de la vista Production.vProductoConCosto, relacionando los productos con su historial de costos.
CREATE OR ALTER VIEW Production.vProductoConCosto AS
SELECT
    prod.ProductID,
    prod.Name AS NombreProducto,
    prod.ListPrice AS PrecioLista,
    pch.StandardCost AS CostoEstandar,
    pch.StartDate AS FechaInicio
FROM Production.Product prod
INNER JOIN Production.ProductCostHistory pch
    ON prod.ProductID = pch.ProductID;
GO
-- Consultar los resultados de la vista
SELECT *
FROM Production.vProductoConCosto
ORDER BY ProductID ASC, FechaInicio ASC;
GO

--Ej 3. Creación y ejecución de la función dbo.fnCalcularDescuento para calcular el precio final al aplicar un descuento.
CREATE OR ALTER FUNCTION dbo.fnCalcularDescuento (
    @Precio DECIMAL(18,2),
    @Descuento DECIMAL(5,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @Precio * (1 - @Descuento / 100.0);
END;
GO
-- Probar la función con un precio de 1000 y un descuento del 15 %
SELECT dbo.fnCalcularDescuento(100, 10) AS PrecioConDescuento;
GO

--Ej 4. Creación y ejecución de la función dbo.fnLimpiarTexto para eliminar espacios exteriores, convertir a mayúsculas y reemplazar vocales acentuadas.
CREATE OR ALTER FUNCTION dbo.fnLimpiarTexto (
    @Texto NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
    SET @Texto = UPPER(LTRIM(RTRIM(@Texto)));
    SET @Texto = REPLACE(@Texto, N'Á', N'A');
    SET @Texto = REPLACE(@Texto, N'É', N'E');
    SET @Texto = REPLACE(@Texto, N'Í', N'I');
    SET @Texto = REPLACE(@Texto, N'Ó', N'O');
    SET @Texto = REPLACE(@Texto, N'Ú', N'U');
    SET @Texto = REPLACE(@Texto, N'Ü', N'U');
    RETURN @Texto;
END;
GO
-- Probar la función con un texto que contiene espacios y acentos
SELECT dbo.fnLimpiarTexto(N'  Canción de MÉXICO  ') AS TextoLimpio;
GO

--Ej 5. Creación y ejecución del procedimiento almacenado dbo.uspObtenerProductosCostosos para consultar productos que superan un precio mínimo.
CREATE OR ALTER PROCEDURE dbo.uspObtenerProductosCostosos
    @PrecioMin DECIMAL(18,2)
AS
BEGIN
    SELECT
        prod.ProductID,
        prod.Name AS NombreProducto,
        prod.ListPrice AS PrecioLista
    FROM Production.Product prod
    WHERE prod.ListPrice > @PrecioMin
    ORDER BY prod.ListPrice ASC;
END;
GO
-- Probar el procedimiento con un precio mínimo de 2000
EXEC dbo.uspObtenerProductosCostosos @PrecioMin = 2000;
GO


--Ej 6. Ejecución del procedimiento almacenado dbo.uspObtenerProductosCostosos con un precio mínimo de 1000.
EXEC dbo.uspObtenerProductosCostosos @PrecioMin = 1000;
GO

