set lines 125 pages 1000 echo off feed on
col sid form a6
col serial# form 999999
col inst_id form 999 heading INST|ID
col id1 form 99999999
col id2 form 99999999
col lmode form a15
col request form a15
col block form 9999
col blocking_session form 9999999 heading BLOCKING|SESSION
col seconds_in_wait form a8 heading SECONDS|IN_WAIT
col blocker form a8

alter session set "_optimizer_cost_based_transformation"=off;
SELECT DECODE(l.request,0,'Holder:',' Waiter:') blocker, lpad(' ',DECODE(l.request,0,0,1))||l.sid sid,
       s.serial#, l.inst_id, to_char(trunc(sysdate) + (l.ctime/24/60/60), 'HH24:MI:SS') seconds_in_wait, 
       s.status, s.logon_time, 
       --decode(l.request, 0, s.sql_id, null, s.prev_sql_id, s.prev_sql_id) sql_id, s.sql_hash_value,
       DECODE(l.request,0,'',' ')||decode(s.sql_id, null, s.prev_sql_id, s.sql_id) sql_id,
       decode(l.lmode,
              0,'(0)None',
              1,'(1)Null',
              2,'(2)Row Share',
              3,'(3)Row Exclu',
              4,'(4)Share',
              5,'(5)Share Row Ex',
              6,'(6)Exclusive') lmode,
       decode(l.request,
              0,'(0)None',
              1,'(1)Null',
              2,'(2)Row Share',
              3,'(3)Row Exclu',
              4,'(4)Share',
              5,'(5)Share Row Ex',
              6,'(6)Exclusive') request,
       l.type, l.block
  FROM gv$session s, gv$lock l
 WHERE EXISTS (SELECT 1 FROM gv$lock o WHERE o.lmode = 0 and o.id1 = l.id1 and o.id2 = l.id2)
   and l.inst_id = s.inst_id
   and l.sid = s.sid
--   and l.lmode=6
--   and l.request=0
--   and l.block>1
--   and l.ctime > 600
ORDER BY l.id1,l.request;

col sid form a6
set feed on
--@kill_script.sql
--@hostinvobj.sql

