--Tarea M10 - Santiago Gonzalez

--Ej 1: Consulta en base del ProductID de el numero total de ventas y el valor de las ventas
SELECT s.ProductID,
    SUM(s.OrderQty) AS TotalQuantity,
    SUM(s.LineTotal) AS TotalSales 
FROM Sales.SalesOrderDetail s
GROUP BY s.ProductID;

--Ej 2: Consulta en base del ProductID de el numero total de ventas filtrando para mostrar solo los que tienen mas de 50 ventas
SELECT s.ProductID,
    SUM(s.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail s
GROUP BY s.ProductID
HAVING SUM(s.OrderQty) > 50;

--Ej 3: Consulta que muestra SalesOrderID, ProductID, LineTotal y ventas total usando OVER + PARTITION BY dentro de SalesOrderID
SELECT s.SalesOrderID, s.ProductID, s.LineTotal,
    SUM(s.LineTotal) OVER (PARTITION BY s.SalesOrderID) AS TotalOrderValue
FROM Sales.SalesOrderDetail s; 

--Ej 4: Consulta que muestra SalesOrderID,SalesOrderDetailID ,ProductID y LineTotal ROW_NUMBER para numerar cada lineadentro de SalesOrderID
SELECT s.SalesOrderID, s.SalesOrderDetailID, s.ProductID, s.LineTotal, ROW_NUMBER() OVER (PARTITION BY s.SalesOrderID ORDER BY s.SalesOrderDetailID) AS ROW_NUMBER
FROM Sales.SalesOrderDetail s;

--Ej 5: Consulta que muestra SalesOrderID, ProductID y LineTotal y asigna rango a SalesOrderID con RANK
SELECT s.SalesOrderID, s.ProductID, s.LineTotal, RANK() OVER (PARTITION BY s.SalesOrderID ORDER BY s.LineTotal DESC) AS Rank
FROM Sales.SalesOrderDetail s;

--Ej 6: Consulta que muestra SalesOrderID, ProductID y LineTotal y asigna rango a SalesOrderID con DENSE_RANK
SELECT s.SalesOrderID, s.ProductID, s.LineTotal, DENSE_RANK() OVER (PARTITION BY s.SalesOrderID ORDER BY s.LineTotal DESC) AS DenseRank
FROM Sales.SalesOrderDetail s;

--Ej 7: COnsulta que en base de ProductID y la suma total de las ventas donde se filtran los productos con un valor menor a $5000 usando HAVING y ordenados por el el valor total en orden descendente
SELECT ProductID, SUM(LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > 5000
ORDER BY SUM(LineTotal) DESC;
