set lines 600 pages 600
col file_name for a40
select file_name, tablespace_name, bytes, status, maxbytes, autoextensible, increment_by
from dba_data_files
order by tablespace_name, file_name;
