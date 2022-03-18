col sid form 9999
col serial# form 9999999
col spid form a9
col username form a11
col program form a35
col terminal form a15
col status form a8

select s.sid, s.serial#, p.spid, s.username, s.status, s.logon_time, s.program, s.terminal, s.module
from   v$session s, v$process p
where  s.username is not null
and    s.paddr = p.addr
and    s.status = 'ACTIVE'
order by s.status, s.logon_time desc
/
