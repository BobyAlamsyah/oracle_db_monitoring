SET lines 600 pages 600
col username for a10
col object_owner for a9
col object_name for a15
col locked_mode for a80
col logon_time for a15
col locked_mode for a15
col os_user_name for a15
SELECT lo.session_id AS sid,
       s.serial#,
       s.status,
       NVL(lo.oracle_username, '(oracle)') AS username,
       o.owner AS object_owner,
       s.logon_time,
       o.object_name,s.event,
       Decode(lo.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             lo.locked_mode) locked_mode,s.row_wait_obj#,
       lo.os_user_name,s.sql_id
FROM   v$locked_object lo
       JOIN dba_objects o ON o.object_id = lo.object_id
       JOIN v$session s ON lo.session_id = s.sid
       ORDER BY 7, 1, 2, 3;
