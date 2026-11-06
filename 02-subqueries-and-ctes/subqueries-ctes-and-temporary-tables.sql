--Tarea M11 - Santiago Gonzalez

--Ej 1. Subconsulta de los Productos de la tabla Production.Product que se encuentran en Sales.SalesOrderDetail
SELECT prod.Name, prod.ProductID
FROM Production.Product prod
WHERE prod.ProductID IN (
    Select sod.ProductID
    FROM Sales.SalesOrderDetail sod)
ORDER BY prod.Name ASC

--Ej 2. Subconsultas correlacionadas para obtener los nombres de los empleados de Person.Person y sus departamentos actuales de HumanResources.Department, utilizando HumanResources.Employee y HumanResources.EmployeeDepartmentHistory
SELECT 
    emp.BusinessEntityID,
    (SELECT per.FirstName + ' ' + per.LastName AS NombreEmpleado
    FROM Person.Person per
    WHERE per.BusinessEntityID = emp.BusinessEntityID
    ) AS NombreDelEmpleado,
    (SELECT dep.Name
    FROM HumanResources.Department dep
    WHERE dep.DepartmentID = (
        SELECT edh.DepartmentID
        FROM HumanResources.EmployeeDepartmentHistory edh
        WHERE edh.BusinessEntityID = emp.BusinessEntityID
            AND edh.EndDate IS NULL
    )
    ) AS NombreDelDepartamento
FROM HumanResources.Employee emp
ORDER BY emp.BusinessEntityID ASC;

--Ej 3. CTE para obtener los nombres de los empleados y sus departamentos actuales, relacionando las tablas de empleados, personas e historial de departamentos.
WITH Empleados AS (
    SELECT
        emp.BusinessEntityID,
        per.FirstName + ' ' + per.LastName AS NombreDelEmpleado,
        dep.Name AS NombreDelDepartamento
    FROM HumanResources.Employee emp
    INNER JOIN Person.Person per
        ON emp.BusinessEntityID = per.BusinessEntityID
    INNER JOIN HumanResources.EmployeeDepartmentHistory edh
        ON emp.BusinessEntityID = edh.BusinessEntityID
    INNER JOIN HumanResources.Department dep
        ON edh.DepartmentID = dep.DepartmentID
    WHERE edh.EndDate IS NULL
)
SELECT
    BusinessEntityID,
    NombreDelEmpleado,
    NombreDelDepartamento
FROM Empleados
ORDER BY BusinessEntityID ASC;

--Ej 4. Creación de tablas temporales local y global para almacenar los identificadores y nombres de los productos de Production.Product, utilizando INSERT INTO para insertar los registros.
-- Crear tabla temporal local
CREATE TABLE #ProductosLocal ( 
    ProductID INT,
    Name NVARCHAR(50)
);
-- Crear tabla temporal global
CREATE TABLE ##ProductosGlobal ( 
    ProductID INT,
    Name NVARCHAR(50)
);
-- Insertar datos en la tabla temporal local
INSERT INTO #ProductosLocal (ProductID, Name)
SELECT
    ProductID,
    Name
FROM Production.Product
ORDER BY Name ASC;
-- Insertar datos en la tabla temporal global
INSERT INTO ##ProductosGlobal (ProductID, Name)
SELECT
    ProductID,
    Name
FROM Production.Product;
-- Consultar los resultados
SELECT * FROM #ProductosLocal
ORDER BY Name ASC;
SELECT * FROM ##ProductosGlobal
ORDER BY Name ASC;

--Ej 5. Consulta de los números de orden y números de compra de la tabla Sales.SalesOrderHeader, filtrando únicamente los registros del año 2011.
SELECT
    SalesOrderNumber,
    PurchaseOrderNumber
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011;

--Ej 6. Consulta de los números de orden y compra de Sales.SalesOrderHeader, utilizando SUBSTRING para eliminar los primeros dos caracteres y renombrar las columnas resultantes.
SELECT
    SUBSTRING(SalesOrderNumber, 3, LEN(SalesOrderNumber)) AS NewSalesOrderNumber,
    SUBSTRING(PurchaseOrderNumber, 3, LEN(PurchaseOrderNumber)) AS NewPurchaseOrderNumber
FROM Sales.SalesOrderHeader;