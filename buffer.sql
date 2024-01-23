set lines 200
set pages 0
select sysdate, executions,buffer_gets,buffer_gets/executions,disk_reads,sql_id from v$sqlarea where sql_id='79yrcvp34q44c';
exit;
