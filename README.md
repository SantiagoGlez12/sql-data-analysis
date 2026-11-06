# SQL for Data Analysis

A collection of my SQL Server coursework, from analytical queries and reusable database objects to database administration and relational modeling.

**SQL Server · T-SQL · Window Functions · CTEs · Database Design · Docker**

## Explore the exercises

| Area | Skills demonstrated | Database/context |
| --- | --- | --- |
| [Analytical queries](01-analytical-queries) | Aggregation, HAVING, partitioned sums, ROW_NUMBER, RANK, DENSE_RANK | AdventureWorks OLTP |
| [Subqueries and CTEs](02-subqueries-and-ctes) | Correlated subqueries, joins, CTEs, temporary tables, date and string functions | AdventureWorks OLTP |
| [Database objects](03-database-objects) | Views, scalar functions, parameterized stored procedures | AdventureWorks OLTP |
| [Paperclip](04-paperclip) | Schemas, tables, CSV loading, restricted read access, backup and restoration | Standalone SQL Server lab |
| [AudioLink Events](05-audiolink-model) | Eight-table schema, primary/foreign keys, uniqueness and CHECK constraints | Fictional event/equipment scenario |
| [Earlier table operations](docs/module-08.md) | Summary of the submitted CREATE/ALTER/INSERT/DELETE/TRUNCATE/DROP exercise | Screenshot-based coursework report |

## How to use this collection

Use SQL Server and a SQL client that supports T-SQL and `GO` batch separators. The first three exercise scripts expect an AdventureWorks OLTP database with the referenced Sales, Production, Person, and HumanResources schemas. Select that database in your client before running the exercises. The sample database itself is not redistributed here.

Paperclip and AudioLink create separate databases. Read their folder READMEs before running scripts. The original Spanish object names and comments are preserved.

This repository documents learning work rather than a single application with one installation command. Database creation, login creation, import paths, and restoration require different permissions and preparation.

## Migration and validation

- The source scripts and small Paperclip datasets are preserved byte-for-byte from Drive.
- Paperclip CSVs contain only integer identifier columns: 10 departments, 100 employees, 200 clients, 500 orders, and 1,000 products (1,810 rows total).
- Both shell scripts passed `bash -n`; this checks syntax without running Docker or changing a server.
- SQL execution, query results, and restoration have not been revalidated: no configured SQL Server or AdventureWorks instance is available in this environment.
- Known comment/code mismatches and platform assumptions are recorded in the [review notes](docs/review-notes.md).

The [source manifest](docs/source-manifest.json) records the original paths and Git blob hashes. A duplicate M12 script differed only in its heading and trailing whitespace; one copy is published. Course slides, duplicate renderings, the original screenshot PDF, and the generated `.bak` are not included. Original files remain unchanged in Drive.

The evolving Empresa Aliada retail project is handled separately from this exercise collection.
