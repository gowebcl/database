drop function if exists application_configurations_del_account;

create or replace function application_configurations_del_account (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_account numeric;
    var_idf_community numeric;
    var_txt_function text = 'application_configurations_del_account';
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_idf_account = environment_core_get_json_numeric (incoming_object, 'idf_account');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    update dat_accounts set
        sys_status = false,
        sys_user = var_sys_user
    where
        sys_status = true
        and idf_community = var_idf_community
        and idf_account = var_idf_account;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;