# Aggregation and Window Functions

Module 10 exercises over `Sales.SalesOrderDetail` in AdventureWorks OLTP.

- Product quantities and sales totals with `SUM` and `GROUP BY`.
- Group filtering with `HAVING`.
- Order-level sums with `OVER (PARTITION BY ...)`.
- Sequential numbering and ranking within each order.

Select the AdventureWorks database before opening `aggregation-and-window-functions.sql`. The original seven queries are unchanged. In exercise 7 the comment says values below 5,000, while the query filters `SUM(LineTotal) > 5000`; the SQL determines the actual behavior.
