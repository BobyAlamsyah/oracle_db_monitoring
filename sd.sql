set lines 180 pages 1000
select inst_id,sql_id, child_number, plan_hash_value, executions, buffer_gets,
round(buffer_gets/case when nvl(executions,0)=0 then 1 else executions end) "BG/EX",
module, rows_processed,
(elapsed_time/1000000/case when nvl(executions,0)=0 then 1 else executions end) elapsed_exec
from gv$sql
where sql_id='&sqlid'
order by inst_id
/
