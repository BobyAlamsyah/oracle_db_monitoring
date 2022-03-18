select  NAME, TOTAL_MB, FREE_MB, USABLE_FILE_MB,  STATE, round(((FREE_MB/TOTAL_MB)*100),2) FREE_PCT from v$asm_diskgroup;
