drop function if exists environment_generic_get_status;

create or replace function environment_generic_get_status (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_rows numeric;
    var_num_size numeric;
    var_obj_tables json;
    var_txt_function text = 'environment_generic_get_status';
    var_txt_size text;
    var_txt_timestamp text;
    var_txt_timezone text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');
/*
    select
        current_timestamp,
        current_setting ('timezone')
    into
         var_txt_timestamp,
         var_txt_timezone;

    select
        sum (n_live_tup),
        sum (pg_total_relation_size (relname::text)),
        pg_size_pretty (sum (pg_total_relation_size (relname::text)))
    into
        var_num_rows,
        var_num_size,
        var_txt_size
    from
        pg_stat_user_tables
    where
        schemaname = 'public';

    select
        array_to_json (
            array_agg (returned)
        )
    into
        var_obj_tables
    from (
        select
            relname "txt_table",
            n_live_tup "nun_row",
            pg_total_relation_size (relname::text) "num_size",
            pg_size_pretty (pg_total_relation_size (relname::text)) "txt_size"
        from
            pg_stat_user_tables
        where
            schemaname = 'public'
        order by
            relname
    ) returned;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_rows', var_num_rows);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_size', var_num_size);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_timestamp', var_txt_timestamp);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_timezone', var_txt_timezone);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_size', var_txt_size);
    outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_tables', var_obj_tables);
*/
    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;