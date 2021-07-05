::psdual::
	Send, select{SPACE}{SPACE}from dual;{LEFT 11}
return

::psel::
	Send, select * from{SPACE}
return

::pcount::
	Send, select count(1) from{SPACE};{LEFT}
return

::psinsert::
	Send, insert into {SHIFTDOWN}90{SHIFTUP} values {SHIFTDOWN}90{SHIFTUP}{LEFT 11}
return

::psupdate::
	Send, update  set{SPACE}|{SPACE}where{SPACE}|{LEFT 14}
	SetKeyDelay, 0
	KeyWait,Enter, D
	Send, {BACKSPACE}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{BACKSPACE}
	Sleep, 700
	KeyWait,Enter, D
	Send, {BACKSPACE}{END}{BACKSPACE}
return

::psdelete::
	Send, delete from{SPACE}{SPACE}where{SPACE}|{LEFT 8}
	SetKeyDelay, 0
	KeyWait,Enter, D
	Send, {BACKSPACE}{END}{BACKSPACE}
return

::psatables::
	SetKeyDelay, 20
	Send, select a.owner, a.table_name, 'select * from '||a.owner||'.'||a.table_name||';', a.*
	send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}from all_tables a 
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}where a.owner like upper('{SHIFTDOWN}55{SHIFTUP}') and a.table_name like upper('{SHIFTDOWN}55{SHIFTUP}');
	Send, {LEFT 7}
	SetKeyDelay, 0
return

::psatab::
	SetKeyDelay, 20
	Send, select * from all_tab_columns where column_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 6}
	SetKeyDelay, 0
return

::psaseq::
	SetKeyDelay, 20
	
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}select 'select '||s.sequence_owner||'.'||s.sequence_name||'.nextval from dual;' c_nextval,{ENTER}
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}       'select '||s.sequence_owner||'.'||s.sequence_name||'.currval from dual;' c_currval,{ENTER}
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}       s.*{ENTER}
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}  from all_sequences s{ENTER}
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE} where s.sequence_owner like upper('{SHIFTDOWN}55{SHIFTUP}'){ENTER}
	Send, {SPACE}{SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}   and s.sequence_name like upper('{SHIFTDOWN}55{SHIFTUP}');{LEFT 7}
	
	SetKeyDelay, 0
return

::psasrc::
	SetKeyDelay, 20
	Send, select * from all_source where upper(text) like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psacons::
	SetKeyDelay, 20
	Send, select * from all_constraints where constraint_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psaconscol::
	SetKeyDelay, 20
	Send, select * from all_cons_columns where constraint_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psaobj::
	SetKeyDelay, 20
	Send, select * from all_objects where object_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psatrg::
	SetKeyDelay, 20
	Send, select * from all_triggers where trigger_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psatrgwt::
	SetKeyDelay, 20
	Send, select * from all_triggers where table_name like upper('{SHIFTDOWN}55{SHIFTUP}');{SPACE}
	Send, {LEFT 8}
	SetKeyDelay, 0
return

::psacolvalue::
	vSql := "WITH PARAM AS" . "`n"
	vSql .= "  (SELECT '%4 Malas%' SEARCH," . "`n"
	vSql .= "          '%%' COLUMN_NAME," . "`n"
	vSql .= "          'VARCHAR2' COLUMN_TYPE," . "`n"
	vSql .= "          '%LOCADORA%' OWNER" . "`n"
	vSql .= "     FROM DUAL)" . "`n"
	vSql .= "SELECT *" . "`n"
	vSql .= "  FROM (SELECT 0 ORDEM, 'Select VW.* from (' COPY FROM DUAL" . "`n"
	vSql .= "        UNION" . "`n"
	vSql .= "`n"
	vSql .= "        SELECT 1 ORDEM, 'select ''SELECT T.'||ATC.COLUMN_NAME||', T.* FROM '||ATC.owner||'.'||ATC.table_name||' T WHERE UPPER(T.'||ATC.column_name||') LIKE UPPER('''''||param.search||''''');'' cSelect, count(1) qtd from '||ATC.owner||'.'||ATC.table_name||' t where UPPER(t.'||ATC.column_name||') LIKE UPPER('''||param.search||''') union '  COPY" . "`n"
	vSql .= "          FROM ALL_TAB_COLUMNS ATC," . "`n"
	vSql .= "               PARAM" . "`n"
	vSql .= "         WHERE ATC.COLUMN_NAME LIKE UPPER('%%%%%')" . "`n"
	vSql .= "           --and ATC.TABLE_NAME NOT LIKE UPPER('%_HST')" . "`n"
	vSql .= "           and ATC.DATA_TYPE = PARAM.COLUMN_TYPE" . "`n"
	vSql .= "           and ATC.OWNER LIKE PARAM.OWNER" . "`n"
	vSql .= "`n"
	vSql .= "        UNION" . "`n"
	vSql .= "        SELECT 2 ORDEM, 'SELECT NULL, NULL FROM DUAL WHERE 1 = 2) vw where vw.qtd > 0;' COPY FROM DUAL) VW" . "`n"
	vSql .= "ORDER BY VW.ORDEM;" . "`n"
	ClipBoard := vSql
	Send, ^v
return

::like::
	SetKeyDelay, 20
	Send, like upper('{SHIFTDOWN}55{SHIFTUP}')
	Send, {LEFT 6}
	SetKeyDelay, 0
return

::pdbms::
	Send, dbms_output.put_line();{LEFT 2}
return

::ptodt::
	Send, to_date('', 'dd/mm/rrrr'){LEFT 16}
return
::ptodt2::
	Send, to_date('', 'rrrr-mm-dd'){LEFT 16}
return


::psatablesnl::
	Send, select a.owner, a.table_name, 'select * from '||a.owner||'.'||a.table_name||';', a.*
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}from all_tables a
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}where a.table_name not like '{SHIFTDOWN}5{SHIFTUP}_HST'

	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and a.table_name not like '{SHIFTDOWN}5{SHIFTUP}_BKP'

	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and a.owner like upper('{SHIFTDOWN}55{SHIFTUP}')

	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and a.table_name like upper('{SHIFTDOWN}55{SHIFTUP}');
	Send, {LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}
return

::psatabnl::
	Send, select *
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}from all_tab_columns
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}where table_name not like '{SHIFTDOWN}5{SHIFTUP}_HST'
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and table_name not like '{SHIFTDOWN}5{SHIFTUP}_BKP'
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and table_name not like '{SHIFTDOWN}5{SHIFTUP}_TMP'
	Send, {ENTER}{SPACE}
	Send, {SHIFTDOWN}{HOME}{SHIFTUP}{BACKSPACE}
	Send, {SPACE}{SPACE}{SPACE}and column_name like upper('{SHIFTDOWN}55{SHIFTUP}');
	Send, {LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}
return


