drop function if exists application_configurations_set_category;

create or replace function application_configurations_set_category (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_category numeric;
    var_idf_community numeric;
    var_txt_category text;
    var_txt_function text = 'application_configurations_set_category';
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_category = environment_core_get_next_sequence ('seq_categories');
    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_txt_category = environment_core_get_json_text (incoming_object, 'txt_category');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    insert into dat_categories (
        sys_user,
        idf_category,
        txt_category,
        idf_community
    ) values (
        var_sys_user,
        var_idf_category,
        var_txt_category,
        var_idf_community
    );

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_category', var_idf_category);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;