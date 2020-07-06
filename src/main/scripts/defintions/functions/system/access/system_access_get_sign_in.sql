drop function if exists system_access_get_sign_in;

create or replace function system_access_get_sign_in (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_person numeric;
    var_idf_user numeric;
    var_num_count numeric;
    var_txt_business_name text;
    var_txt_first_name text;
    var_txt_function text = 'system_access_get_sign_in';
    var_txt_last_name text;
    var_txt_user_name text;
    var_txt_username text;
    var_txt_password_decrypted text;
    var_txt_password_encrypted text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();

    var_txt_password_decrypted = lower (environment_core_get_json_text (incoming_object, 'txt_password'));
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
        and txt_username = var_txt_username
        and txt_password = var_txt_password_encrypted;

    if (var_num_count = 0) then

        return environment_core_get_function_result (var_sys_user, var_txt_function, 11003, incoming_object, outgoing_object);

    end if;

    select
        idf_person,
        idf_user,
        txt_business_name,
        txt_first_name,
        txt_last_name
    into
        var_idf_person,
        var_idf_user,
        var_txt_business_name,
        var_txt_first_name,
        var_txt_last_name
    from
        dat_users
    where
        sys_status = true
        and txt_username = var_txt_username
        and txt_password = var_txt_password_encrypted;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_user', var_idf_user);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_person_type', var_idf_person);

    if (var_idf_person = 1) then

        var_txt_user_name = trim (var_txt_first_name || ' ' || var_txt_last_name);

    else

        var_txt_user_name = trim (var_txt_business_name);

    end if;

    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_user_name', var_txt_user_name);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;