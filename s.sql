set lines 300 pages 50000 time on
col username for a15
col osuser for a14
col event for a33
col ins for 9
col sid for 99999
col et for 9999999
col dt for a20
col system_date for a18
col module for a10 trunc
col blocker for 999999
col bs for 99999
col osuser for a12
select systimestamp from dual;
select inst_id as ins,sid,username,sql_id,event,p1,p2,module,last_call_et as et, row_wait_obj# as obj,ROW_WAIT_ROW# as rr, BLOCKING_SESSION BS,blocking_instance bi
from gv$session
where wait_class !='Idle'
order by inst_id,event
/
