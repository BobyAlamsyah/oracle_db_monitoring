set serveroutput on
DECLARE
  l_plans_loaded  PLS_INTEGER;
  BEGIN
    l_plans_loaded := DBMS_SPM.load_plans_from_awr(begin_snap=>&begin_snap,end_snap=>&end_snap,basic_filter=>q'# sql_id='&sql_id' and plan_hash_value='&plan_hash_value' #');
    END;
    /
