declare
  ar_hint_table    sys.dbms_debug_vc2coll;
  ar_profile_hints sys.sqlprof_attr := sys.sqlprof_attr();
  cl_sql_text      clob;
  i                pls_integer;
begin
  with a as (
  select
           rownum as r_no
         , a.*
  from
           table(
              dbms_xplan.display_awr(
                '&sqlid'
              , &hash_value
              , null
              , 'OUTLINE'
              )
           ) a
  ),
  b as (
  select
           min(r_no) as start_r_no
  from
           a
  where
           a.plan_table_output = 'Outline Data'
  ),
  c as (
  select
           min(r_no) as end_r_no
  from
           a
         , b
  where
           a.r_no > b.start_r_no
  and      a.plan_table_output = '  */'
  ),
  d as (
  select
           instr(a.plan_table_output, 'BEGIN_OUTLINE_DATA') as start_col
  from
           a
         , b
  where
           r_no = b.start_r_no + 4
  )
  select
           substr(a.plan_table_output, d.start_col) as outline_hints
  bulk collect
  into
           ar_hint_table
  from
           a
         , b
         , c
         , d
  where
           a.r_no >= b.start_r_no + 4
  and      a.r_no <= c.end_r_no - 1
  order by
           a.r_no;

  select
           sql_text
  into
           cl_sql_text
  from
           sys.dba_hist_sqltext
  where
           sql_id = '&sqlid';

  -- this is only required
  -- to concatenate hints
  -- splitted across several lines
  -- and could be done in SQL, too
  i := ar_hint_table.first;
  while i is not null
  loop
    if ar_hint_table.exists(i + 1) then
      if substr(ar_hint_table(i + 1), 1, 1) = ' ' then
        ar_hint_table(i) := ar_hint_table(i) || trim(ar_hint_table(i + 1));
        ar_hint_table.delete(i + 1);
      end if;
    end if;
    i := ar_hint_table.next(i);
  end loop;

  i := ar_hint_table.first;
  while i is not null
  loop
    ar_profile_hints.extend;
    ar_profile_hints(ar_profile_hints.count) := ar_hint_table(i);
    i := ar_hint_table.next(i);
  end loop;

  dbms_sqltune.import_sql_profile(
    sql_text    => cl_sql_text
  , profile     => ar_profile_hints
  , name        => 'SQL_PROF_&sqlid'
  -- use force_match => true
  -- to use CURSOR_SHARING=SIMILAR
  -- behaviour, i.e. match even with
  -- differing literals
  , force_match => true
  );
end;
/
