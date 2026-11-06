# Views, Functions and Stored Procedures

Module 12 creates or alters the following objects in the selected AdventureWorks database:

| Object | Purpose |
| --- | --- |
| `Production.vCostoProductoSimple` | Product ID, name and list price |
| `Production.vProductoConCosto` | Products joined to cost-history records |
| `dbo.fnCalcularDescuento` | Apply a percentage discount |
| `dbo.fnLimpiarTexto` | Trim, uppercase and replace accented vowels |
| `dbo.uspObtenerProductosCostosos` | List products above a supplied price |

The script includes demonstration calls and uses `GO` between batches. The discount example comment mentions 1,000 with 15%, but the actual call is `(100, 10)`. The cost view includes history rows rather than selecting only the latest cost. Text replacement behavior can depend on the database collation. The source has not been changed during migration.
