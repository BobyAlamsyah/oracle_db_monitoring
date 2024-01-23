set pages 80
set lines 130
col c1 heading 'Average Waits for|Full Scan Read I/O' format 999999.999
col c2 heading 'Average Waits for|Index Read I/O' format 999999.999
col c3 heading 'Percent of| I/O Waits|for scattered|Full Scans' format 999.99
col c4 heading 'Percent of| I/O Waits|for sequential|Index Scans' format 999.99
col c5 heading 'Starting|Value|for|optimizer|index|cost|adj' format 99999

select a.snap_id "Snap",
       sum(a.time_waited_micro)/sum(a.total_waits)/10000 c1,
       sum(b.time_waited_micro)/sum(b.total_waits)/10000 c2,
       (sum(a.total_waits) / sum(a.total_waits + b.total_waits)) * 100 c3,
       (sum(b.total_waits) / sum(a.total_waits + b.total_waits)) * 100 c4,
       (sum(b.time_waited_micro)/sum(b.total_waits)) /
(sum(a.time_waited_micro)/sum(a.total_waits)) * 100 c5
from
   dba_hist_system_event a,
   dba_hist_system_event b
where a.snap_id = b.snap_id
and a.event_name = 'db file scattered read'
and b.event_name = 'db file sequential read'
-- and a.snap_id >= (select max(snap_id) from dba_hist_system_event)-48 /* last 24 hours */
and a.snap_id >= (select max(snap_id) from dba_hist_system_event)-4 /* last 2 hours */
group by a.snap_id
order by 1
/
