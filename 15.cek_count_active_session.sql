
col username form a30
set pages 300

set head off;
select 'HOSTNAME : '||host_name FROM v$instance;
select to_char(sysdate, 'DD-MON-YYYY HH:MI:SS') from dual;

set head on;

select inst_id, username, count(*) as active_conn_count 
from gv$session
where username is NOT  NULL and status='ACTIVE' 
group by inst_id, username 
order by inst_id, active_conn_count desc;
