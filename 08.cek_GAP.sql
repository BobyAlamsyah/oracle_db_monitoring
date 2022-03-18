SET LINES 250 PAGES 5000 TIMING ON TRIM ON;
--Check DB information
COL PLATFORM_NAME FOR A30;
COL DB_UNIQUE_NAME FOR A15;
COL CURRENT_SCN FOR A20;
COL HOST_NAME FOR A30;
SELECT NAME,DB_UNIQUE_NAME,INSTANCE_NAME,DBID,HOST_NAME,PLATFORM_NAME,OPEN_MODE,STATUS,LOG_MODE,DATABASE_ROLE,TO_CHAR(CURRENT_SCN)CURRENT_SCN FROM V$DATABASE X,V$INSTANCE Y;

--Check gap on standby DB with gap
SELECT /*Check gap on stby with difference*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied", almax-lhmax "Gap", decode(almax-lhmax, 0, 'Sync', 'Gap') "Result"
FROM (select thread# thrd, MAX(sequence#) almax FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al,
(SELECT thread# thrd, MAX(sequence#) lhmax FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

--Check proses standby
SELECT PROCESS,STATUS,SEQUENCE#,INST_ID FROM GV$MANAGED_STANDBY ORDER BY 1,3,2;

