set lines 125 pages 1000 feed off
col sid form 9999
col serial# form 9999999
col spid form a7
col username form a11
col program form a35
col terminal form a15
col status form a8

alter session set nls_date_format = 'dd-mon-yy hh24:mi';
set feed on

select s.sid, s.serial#, p.spid, s.username, s.status, s.logon_time, s.program, s.terminal, s.sql_id, sq.sql_text
from   v$session s, v$process p, v$sql sq
where  s.username is not null
and    s.paddr = p.addr
and    s.status = 'ACTIVE'
and    s.sql_id = sq.sql_id
order by s.status, s.logon_time desc
/

