drop function if exists environment_generic_exe_delete;

create or replace function environment_generic_exe_delete (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_deletes numeric;
    var_txt_field text;
    var_txt_function text = 'environment_generic_exe_delete';
    var_txt_sentence1 text;
    var_txt_table text;
    var_txt_value text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_txt_field = environment_core_get_json_text (incoming_object, 'txt_field');
    var_txt_table = environment_core_get_json_text (incoming_object, 'txt_table');
    var_txt_value = environment_core_get_json_text (incoming_object, 'txt_value');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    var_txt_sentence1 = 'update ';
    var_txt_sentence1 = var_txt_sentence1 || var_txt_table;
    var_txt_sentence1 = var_txt_sentence1 || ' set sys_status = false where sys_status = true and ';
    var_txt_sentence1 = var_txt_sentence1 || var_txt_field;
    var_txt_sentence1 = var_txt_sentence1 || ' = ';
    var_txt_sentence1 = var_txt_sentence1 || environment_core_get_dynamic_value (var_txt_value);

    execute var_txt_sentence1;

    get diagnostics var_num_deletes = row_count;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_deletes', var_num_deletes);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;