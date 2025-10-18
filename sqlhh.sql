col begin_interval_time for a30
set pages 1000 lines 180
select ss.snap_id, ss.instance_number node, to_char(begin_interval_time,'DD-MON-YY HH24MI') begin_interval_time,  plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio,
(disk_reads_delta/decode(nvl(disk_reads_delta,0),0,1,executions_delta)) avg_pio,
(iowait_delta/decode(nvl(iowait_delta,0),0,1,executions_delta)) avg_iowait,
rows_processed_delta,
elapsed_time_delta/1000000 elap
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id = '&sql_id'
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and executions_delta > 0
union all
select 999999999, I.inst_id, 'CURRENT', plan_hash_value,
nvl(executions,0) execs,
(elapsed_time/decode(nvl(executions,0),0,1,executions))/1000000 avg_etime,
(buffer_gets/decode(nvl(buffer_gets,0),0,1,executions)) avg_lio,
(disk_reads/decode(nvl(disk_reads,0),0,1,executions)) avg_pio,
(user_io_wait_time/decode(nvl(user_io_wait_time,0),0,1,executions)) avg_iowait,
rows_processed,
elapsed_time/1000000 elap
from gv$instance i, gv$sqlarea a
where i.inst_id = a.inst_id
and sql_id = '&sql_id'
and executions > 0
order by 1,2,3
/
