set lines 400 pages 800
col path for a35
select host_name,instance_name,status from v$instance;
select  NAME, TOTAL_MB, FREE_MB, USABLE_FILE_MB,  STATE from v$asm_diskgroup;
select name, header_status from v$asm_disk where header_status <> 'MEMBER';
select NAME,MOUNT_STATUS,TOTAL_MB,FREE_MB,PATH from v$asm_disk order by 1;

