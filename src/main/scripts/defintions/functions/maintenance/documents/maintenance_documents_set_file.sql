drop function if exists maintenance_documents_set_file;

create or replace function maintenance_documents_set_file (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_idf_file numeric;
    var_idf_type numeric;
    var_txt_file text;
    var_txt_function text = 'maintenance_documents_set_file';
    var_txt_location text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'num_community');
    var_idf_file = environment_core_get_next_sequence ('seq_files');
    var_idf_type = environment_core_get_json_numeric (incoming_object, 'idf_type');
    var_txt_file = environment_core_get_json_text (incoming_object, 'txt_file');
    var_txt_location = environment_core_get_json_text (incoming_object, 'txt_location');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    insert into dat_files (
        sys_user,
        idf_community,
        idf_file,
        idf_type,
        txt_file,
        txt_location
    ) values (
        var_sys_user,
        var_idf_community,
        var_idf_file,
        var_idf_type,
        var_txt_file,
        var_txt_location
    );

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_file', var_idf_file);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end
$body$ language plpgsql;