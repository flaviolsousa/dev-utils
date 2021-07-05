### fun_xml2type

Generates dynamic SQL that with an execute_imediate creates the new TYPE of origem of a XMLTYPE({record})

Sample:

```sql
  FUNCTION fun_xml2_pp_hotel(p_xml IN xmltype) RETURN typ_pp_hotel IS
    v_typ_pp_hotel typ_pp_hotel;
    v_sql          VARCHAR2(32767);
    v_cur          SYS_REFCURSOR;
    v_bkp_session  VARCHAR2(4000);
  BEGIN
    v_bkp_session := pkg_gtw_util.fun_set_session_american;
    IF p_xml IS NOT NULL THEN
      v_sql := pkg_gtw_util.fun_xml2type(p_xml);
      OPEN v_cur FOR('select ' || v_sql || ' from dual');
      FETCH v_cur
        INTO v_typ_pp_hotel;
      CLOSE v_cur;
    END IF;
    --
    pkg_gtw_util.prc_set_return_session(v_bkp_session);
    --
    RETURN v_typ_pp_hotel;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              substr(dbms_utility.format_error_backtrace ||
                                     ' - ' || SQLERRM,
                                     1,
                                     3990));
      pkg_gtw_util.prc_set_return_session(v_bkp_session);
      RETURN v_typ_pp_hotel;
  END fun_xml2_pp_hotel;
```

### PACKAGE

```sql
CREATE OR REPLACE PACKAGE BODY PKG_GTW_UTIL IS
  --
  function fun_xml2type(p_element xmltype, p_type_name varchar2 default null, p_element_name varchar2 default null, p_recursive in boolean default false)
  return varchar2
  is
    v_xpath                  varchar2(32767);
    v_type_name              varchar2(100);
    v_element_name           varchar2(100);
    v_type_sub_type          varchar2(100);
    v_value_attr             varchar2(32767);
    v_delimitador            varchar2(2);
    v_delimitador_padrao     varchar2(2):= ',';

    v_arr_delimitador        varchar2(2);
    v_arr_delimitador_padrao varchar2(2):= v_delimitador_padrao;

    v_sub_xml                xmltype;
    v_size                   number(5);
    v_sql                    varchar2(32767);
  begin
    if (not p_recursive) then
      v_id_clob := 0;
    end if;

    if (p_type_name is null) then
      select xmlquery('/*/name()' passing p_element returning content).getClobVal() -- StringVal()
       into v_type_name
       from dual;
    else
      v_type_name := p_type_name;
    end if;

    if (p_element_name is null) then
      v_element_name := v_type_name;
    else
      v_element_name := p_element_name;
    end if;

    v_sql := v_type_name || '(';
    v_delimitador := null;
    for cur in (select * from all_type_attrs where type_name = v_type_name order by attr_no) loop
      v_sql := v_sql || v_delimitador;
      if (cur.attr_type_owner is null) then
        v_xpath := '/*/' || cur.attr_name || '/text()';
        select XMLQuery(v_xpath passing p_element returning content).getClobval() --getStringVal()
          into v_value_attr
          from dual;
        --if (cur.attr_type_name = 'VARCHAR2' or cur.attr_type_name = 'CHAR' or cur.attr_type_name = 'CLOB') then
        if (cur.attr_type_name = 'VARCHAR2' or cur.attr_type_name = 'CHAR') then
          v_value_attr := '''' || v_value_attr || '''';
        elsif (cur.attr_type_name = 'CLOB') then
          v_value_attr := 'pkg_gtw_util.fun_get_clob(' || fun_set_clob(v_value_attr) || ')';
        elsif (cur.attr_type_name = 'DATE') then
          begin
            v_value_attr := '''' || to_date(v_value_attr) || '''';
          exception
            when others then
              if pkg_preferencia.fun_regexp_like(v_value_attr, '^\d{2}-[A-Z]{3}-\d{2}$') = 1 then
                v_value_attr := '''' || to_date(v_value_attr, 'dd MON yyyy', 'NLS_DATE_LANGUAGE=AMERICAN') || '''';
              else
                begin
                  v_value_attr :='''' ||  to_date(v_value_attr,'dd/mm/rrrr hh24:mi:ss') || '''';
                exception
                  when others then
                  raise_application_error(-20000, 'Formato de data invalido');
                end;
              end if;
          end;
        elsif (cur.attr_type_name = 'NUMBER') then
          v_value_attr := replace(v_value_attr, ',', '.');
        end if;

        v_sql := v_sql || nvl(v_value_attr, 'null');

        v_delimitador := v_delimitador_padrao;
      else
        begin
          select 'TYPE'
            into v_type_sub_type
            from all_type_attrs
           where type_name = cur.attr_type_name
             and rownum <= 1;
        exception
          when no_data_found then
            v_type_sub_type := 'ARRAY';
        end;

        if (v_type_sub_type = 'ARRAY') then

          v_sql := v_sql || cur.attr_type_name || '(';
          v_xpath := 'count(/'||v_element_name||'/'||cur.attr_name||'/*)';
          select xmlquery(v_xpath passing p_element returning content).getNumberVal()
            into v_size
            from dual;
          v_arr_delimitador := '';
          for iArr in 1 .. v_size loop
            v_xpath := '/'||v_element_name||'/'||cur.attr_name||'/*['||iArr||']';
            select extract(p_element, v_xpath)
              into v_sub_xml
              from dual;

            v_sql := v_sql || v_arr_delimitador || fun_xml2type(p_element => v_sub_xml, p_recursive => true);

            v_arr_delimitador := v_arr_delimitador_padrao;
          end loop;
          v_sql := v_sql || ')';
          v_delimitador := v_delimitador_padrao;
        elsif (v_type_sub_type = 'TYPE') then
          select extract(p_element, '/'||v_type_name||'/'||cur.attr_name)
            into v_sub_xml
            from dual;

          v_xpath := 'count(/'||v_type_name||'/'||cur.attr_name||'/*)';

          select xmlquery(v_xpath passing p_element returning content).getNumberVal()
            into v_size
            from dual;

          if v_size > 0 then
            v_sql := v_sql || fun_xml2type(p_element => v_sub_xml, p_type_name => cur.attr_type_name, p_element_name => cur.attr_name, p_recursive => true);
          else
            v_sql := v_sql || 'null';
          end if;
        end if;
        v_delimitador := v_delimitador_padrao;
      end if;
    end loop;

    v_sql := v_sql || ')';
    --if (not p_recursive) then
    --  dbms_output.put_line(v_sql);
    --end if;
    return v_sql;

  end fun_xml2type;
  --
  function fun_get_session_parameter(p_parameter in varchar2)
  return varchar2
  is
    v_value varchar2(64);
  begin
    select
      value
    into v_value
    from v$nls_parameters
    where parameter = upper(p_parameter);
    return v_value;
  exception
    when others then
      return '';
  end fun_get_session_parameter;
  --
  procedure prc_config_session_american(p_new_session in out varchar2, p_bkp_session in out varchar2)
    is
      procedure prc_prepare_session_parameter(p_parameter in varchar2, p_value in varchar2, p_new_session in out varchar2, p_bkp_session in out varchar2)
        is
        v_value varchar2(64);
      begin
        --dbms_output.put_line(p_parameter);
        select
          value
        into v_value
        from v$nls_parameters
        where parameter = upper(p_parameter);
        --
        p_new_session := p_new_session || ' ' || p_parameter || '=' || chr(39) || p_value || chr(39);
        p_bkp_session := p_bkp_session || ' ' || p_parameter || '=' || chr(39) || v_value || chr(39);
      end;
  begin
    prc_prepare_session_parameter('nls_language', 'american', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_territory', 'america', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_currency', '$', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_iso_currency', 'america', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_numeric_characters', '.,', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_calendar', 'gregorian', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_date_format', 'rrrr-mm-dd', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_date_language', 'american', p_new_session, p_bkp_session);
    prc_prepare_session_parameter('nls_sort', 'binary', p_new_session, p_bkp_session);
  end;
  --
  function fun_set_session_american return varchar2 is
    v_new_session varchar2(4000);
    v_bkp_session varchar2(4000);
  begin
    prc_config_session_american(v_new_session, v_bkp_session);
    execute_immediate('alter session set'||v_new_session);
    --dbms_output.put_line('alter session set'||v_new_session);
    return v_bkp_session;
  end;
  --
  procedure prc_set_return_session(p_bkp_session in out varchar2) is
  begin
    execute_immediate('alter session set'||p_bkp_session);
    --dbms_output.put_line('alter session set'||p_bkp_session);
  end;
  --
  procedure prc_gravar_log(p_ds_data in gtw_logs.gtw_log.ds_data%type,
                           p_cd_identificador in gtw_logs.gtw_log.cd_identificador%type,
                           p_cd_log in out gtw_logs.gtw_log.cd_log%type,
                           p_cd_artefato in gtw_logs.gtw_log.cd_artefato%type,
                           p_cd_operacao in gtw_logs.gtw_log.cd_operacao%type,
                           p_id_nivel_erro in gtw_logs.gtw_log.id_nivel_erro%type,
                           p_st_tipo_log in gtw_logs.gtw_log.st_tipo_log%type,
                           p_nm_tipo_operacao in gtw_logs.gtw_log.nm_estado_operacao%type,
                           p_ds_mensagem in gtw_logs.gtw_log.ds_mensagem%type default null
                          )
  is
    v_cd_artefato            gtw_logs.gtw_log.cd_artefato%type          := nvl(p_cd_artefato, 1);
    v_cd_operacao            gtw_logs.gtw_log.cd_operacao%type          := nvl(p_cd_operacao, 1);
    v_nm_estado_operacao     gtw_logs.gtw_log.nm_estado_operacao%type   := p_nm_tipo_operacao;
    v_cd_identificador   gtw_logs.gtw_log.cd_identificador%type := p_cd_identificador;
    v_ds_mensagem            gtw_logs.gtw_log.ds_mensagem%type          := p_ds_mensagem;
    v_dt_evento              gtw_logs.gtw_log.dt_evento%type            := sysdate;
    v_ds_data                gtw_logs.gtw_log.ds_data%type              := p_ds_data;
    v_id_nivel_erro          gtw_logs.gtw_log.id_nivel_erro%type        := nvl(p_id_nivel_erro, 5);
    v_st_tipo_log            gtw_logs.gtw_log.st_tipo_log%type          := nvl(p_st_tipo_log, 'T');
    --
    v_bkp_session            varchar2(4000);
    --
    pragma autonomous_transaction;
  begin
    --
    v_bkp_session := fun_set_session_american;
    --
    insert into
      gtw_logs.gtw_log
      (
        cd_artefato,
        cd_operacao,
        nm_estado_operacao,
        cd_identificador,
        ds_mensagem,
        dt_evento,
        ds_data,
        id_nivel_erro,
        st_tipo_log
      )
      values
      (
        v_cd_artefato,
        v_cd_operacao,
        v_nm_estado_operacao,
        v_cd_identificador,
        v_ds_mensagem,
        v_dt_evento,
        v_ds_data,
        v_id_nivel_erro,
        v_st_tipo_log
      ) returning cd_log into p_cd_log;
    --
    prc_set_return_session(v_bkp_session);
    --
    commit;
    --
  exception
    when others then

      prc_set_return_session(v_bkp_session);
      --raise_application_error(-20000,dbms_utility.format_error_backtrace);

  end prc_gravar_log;
  --
  function fun_set_clob(p_clob in clob)
  return number
  is

  begin
    v_id_clob := v_id_clob + 1;
    tab_clob(v_id_clob) := p_clob;
    return v_id_clob;
  end fun_set_clob;
  --
  function fun_get_clob(p_id_clob in number)
  return clob
  is
  begin
    return tab_clob(p_id_clob);
  end fun_get_clob;
  --
end pkg_gtw_util;
```
