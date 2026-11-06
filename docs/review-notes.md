# Review Notes

## What was checked

Source identity and folder references were reviewed. The five Paperclip CSVs were parsed: all rows have one integer identifier column and the expected row counts. Both shell scripts passed `bash -n`. SQL scripts were read for dependencies and side effects; no SQL statements or Docker helpers were executed.

## Preserved limitations

- Module 10 exercise 7: the comment describes totals below 5,000, but the filter uses `> 5000`.
- Module 12 discount demo: the comment describes 1,000 at 15%; the call uses 100 at 10%.
- Paperclip import paths are container paths. The original CODEPAGE option can require adjustment for the target SQL Server platform.
- Paperclip setup changes server default locations and restarts its container. Its restore exercise intentionally drops the practice database. These are documented lab operations, not part of the migration itself.
- AudioLink constraints do not provide scheduling or stock-reservation logic across events.
- The original Paperclip README states no backup is bundled; Drive also contains a later `.bak`. That generated backup is intentionally not included in this source repository.

## Duplicate handling

The M12 script found under M11 and the one under M12 have identical executable statements. Only the heading and final blank line differ. The M12-folder copy is retained, with the alternate source hash recorded in the manifest. No exercise SQL was rewritten.

Modules 6, 7 and 9 contain class guides in the inspected Drive folders, not separate submitted code. They are not represented as authored exercises here. Empresa Aliada is reserved for the next repository.
