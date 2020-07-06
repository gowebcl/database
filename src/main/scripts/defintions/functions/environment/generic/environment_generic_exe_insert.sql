drop function if exists environment_generic_exe_insert;

create or replace function environment_generic_exe_insert (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_inserts numeric;
    var_obj_key text;
    var_obj_row json;
    var_obj_rows json;
    var_txt_function text = 'environment_generic_exe_insert';
    var_txt_sentence1 text;
    var_txt_sentence2 text;
    var_txt_sentence3 text;
    var_txt_sentence4 text;
    var_txt_table text;
    var_txt_value text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_obj_rows = environment_core_get_json_json (incoming_object, 'obj_rows');
    var_txt_table = environment_core_get_json_text (incoming_object, 'txt_table');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    var_txt_sentence1 = 'insert into ';
    var_txt_sentence1 = var_txt_sentence1 || var_txt_table;

    for var_obj_row in
        select
            json_array_elements (var_obj_rows)
        limit 1
    loop

        var_txt_sentence2 = '';

        for var_obj_key in
            select
                json_object_keys (var_obj_row)
        loop

            select
                json_extract_path_text (var_obj_row, var_obj_key)
            into
                var_txt_value;

            var_txt_sentence2 = var_txt_sentence2 || var_obj_key;
            var_txt_sentence2 = var_txt_sentence2 || ', ';

        end loop;

        var_txt_sentence2 = trim (' (' || var_txt_sentence2);
        var_txt_sentence2 = substring (var_txt_sentence2, 0, length (var_txt_sentence2));
        var_txt_sentence2 = var_txt_sentence2 || ') values ';

    end loop;

    var_txt_sentence4 = '';

    for var_obj_row in
        select
            json_array_elements (var_obj_rows)
    loop

        var_txt_sentence3 = '';

        for var_obj_key in
            select
                json_object_keys (var_obj_row)
        loop

            select
                json_extract_path_text (var_obj_row, var_obj_key)
            into
                var_txt_value;

            var_txt_sentence3 = var_txt_sentence3 || environment_core_get_dynamic_value (var_txt_value);
            var_txt_sentence3 = var_txt_sentence3 || ', ';

        end loop;

        var_txt_sentence3 = trim ('(' || var_txt_sentence3);
        var_txt_sentence3 = substring (var_txt_sentence3, 0, length (var_txt_sentence3));
        var_txt_sentence3 = var_txt_sentence3 || '), ';

        var_txt_sentence4 = var_txt_sentence4 || var_txt_sentence3;

    end loop;

    var_txt_sentence4 = substring (var_txt_sentence4, 0, length (var_txt_sentence4) - 1);
    var_txt_sentence4 = var_txt_sentence4 || ';';

    execute var_txt_sentence1 || var_txt_sentence2 || var_txt_sentence4;

    get diagnostics var_num_inserts = row_count;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_inserts', var_num_inserts);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;