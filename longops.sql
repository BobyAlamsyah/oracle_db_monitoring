set feed off lines 300 pages 1000
alter session set nls_date_format='DD-MON-YY HH24:MI:SS';
set feed on
col sid form 999999
col serial# form 9999999
col username form a8
col message form a90
col remaining form a9

select sid, serial#, username, start_time, last_update_time, to_char(trunc(sysdate)+(time_remaining/1/24/60/60),'HH24:MI:SS') remaining, to_char(trunc(sysdate)+(elapsed_seconds/24/60/60),'HH24:MI:SS') elapsed, round(sofar/totalwork,2)*100 pct_progress, message from v$session_longops where totalwork > sofar;
