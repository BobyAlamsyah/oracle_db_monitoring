
SELECT name, free_mb, total_mb, free_mb/total_mb*100 as Free_usage FROM v$asm_diskgroup;
