drop function if exists system_access_put_password;

create or replace function system_access_put_password (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_count numeric;
    var_num_updates numeric;
    var_txt_function text = 'system_access_put_password';
    var_txt_password_decrypted text;
    var_txt_password_encrypted text;
    var_txt_username text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_txt_password_decrypted = environment_core_get_json_text (incoming_object, 'txt_password');
    var_txt_password_encrypted = digest (var_txt_password_decrypted, 'sha256');
    var_txt_username = lower (environment_core_get_json_text (incoming_object, 'txt_username'));
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    select
        count (*)
    into
        var_num_count
    from
        dat_users
    where
        sys_status = true
        and txt_username = var_txt_username;

    if (var_num_count = 0) then

        return environment_core_get_function_result (var_sys_user, var_txt_function, 11002, incoming_object, outgoing_object);

    end if;

    update dat_users set
        txt_password = var_txt_password_encrypted
    where
        txt_username = var_txt_username;

    get diagnostics var_num_updates = row_count;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_updates', var_num_updates);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;