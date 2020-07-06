drop function if exists application_configurations_put_subcategory;

create or replace function application_configurations_put_subcategory (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_idf_subcategory numeric;
    var_num_updates numeric;
    var_txt_function text = 'application_configurations_put_subcategory';
    var_txt_subcategory text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_idf_subcategory = environment_core_get_json_numeric (incoming_object, 'idf_subcategory');
    var_txt_subcategory = environment_core_get_json_numeric (incoming_object, 'txt_subcategory');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    update dat_subcategories set
        sys_user = var_sys_user,
        txt_subcategory = var_txt_subcategory
    where
        sys_status = true
        and idf_community = var_idf_community
        and idf_subcategory = var_idf_subcategory;

    get diagnostics var_num_updates = row_count;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_updates', var_num_updates);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;