select name from v$database;
set serveroutput on
DECLARE
read_timwait_bef number(30,2);
read_totwait_bef number(30,2);
read_timwait_aft number(30,2);
read_totwait_aft number(30,2);
write_timwait_bef number(30,2);
write_totwait_bef number(30,2);
write_timwait_aft number(30,2);
write_totwait_aft number(30,2);
read_latency number(30,2) := 0;
write_latency number(30,2) := 0;
qry varchar2(1000);
cursor r1 is select round(sum(time_waited_micro)/1000) time_waited_ms, sum(total_waits) total_waits from v$system_event
where event in ('db file sequential read','db file scattered read','direct path read','direct path read temp');
cursor r2 is select round(sum(time_waited_micro)/1000) time_waited_ms, sum(total_waits) total_waits from v$system_event
where event in ('db file sequential read','db file scattered read','direct path read','direct path read temp');
cursor w1 is select round(sum(time_waited_micro)/1000) time_waited_ms, sum(total_waits) total_waits from v$system_event
where event in ('log file parallel write','direct path write','direct path write temp');
cursor w2 is select round(sum(time_waited_micro)/1000) time_waited_ms, sum(total_waits) total_waits from v$system_event
where event in ('log file parallel write','direct path write','direct path write temp');
BEGIN
--open s;
for i in r1
loop
read_timwait_bef := i.time_waited_ms;
read_totwait_bef := i.total_waits;
dbms_output.put_line('Read Bef: '||read_timwait_bef ||' '|| read_totwait_bef);
end loop;
for k in w1
loop
write_timwait_bef := k.time_waited_ms;
write_totwait_bef := k.total_waits;
dbms_output.put_line('Write Bef: '||write_timwait_bef ||' '|| write_totwait_bef);
end loop;
for i in 1..500000
loop
execute immediate 'select null from dual';
end loop;
for j in r2
loop
read_timwait_aft := j.time_waited_ms;
read_totwait_aft := j.total_waits;
dbms_output.put_line('Read Aft: '||read_timwait_aft ||' '|| read_totwait_aft);
end loop;
for l in w1
loop
write_timwait_aft := l.time_waited_ms;
write_totwait_aft := l.total_waits;
dbms_output.put_line('Write Aft: '||write_timwait_aft ||' '|| write_totwait_aft);
end loop;
if read_totwait_bef < read_totwait_aft then
read_latency := (read_timwait_aft - read_timwait_bef) / (read_totwait_aft - read_totwait_bef);
end if;
if write_totwait_bef < write_totwait_aft then
write_latency := (write_timwait_aft - write_timwait_bef) / (write_totwait_aft - write_totwait_bef);
end if;
qry := 'select :1,:2 from dual';
--dbms_output.put_line(qry);
--execute immediate qry using read_latency,write_latency;
dbms_output.put_line('Read Latency '|| read_latency);
dbms_output.put_line('Write Latency '|| write_latency);
END;
/
exit;
