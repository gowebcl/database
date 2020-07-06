drop function if exists application_configurations_get_subcategory;

create or replace function application_configurations_get_subcategory (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_idf_subcategory numeric;
    var_num_subcategories numeric;
    var_obj_subcategories json;
    var_txt_function text = 'application_configurations_get_subcategory';
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
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    if (var_idf_subcategory is null) then

        select
            count (*)
        into
            var_num_subcategories
        from
            dat_subcategories
        where
            sys_status = true
            and idf_community = var_idf_community
            and idf_subcategory = var_idf_subcategory;

        select
            array_to_json (
                array_agg (returned)
            )
        into
            var_obj_subcategories
        from (
            select
                idf_subcategory,
                txt_subcategory
            from
                dat_subcategories
            where
                sys_status = true
                and idf_community = var_idf_community
                and idf_subcategory = var_idf_subcategory
        ) returned;

        outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_subcategories', var_num_subcategories);
        outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_subcategories', var_obj_subcategories);

    else

        select
            idf_subcategory,
            txt_subcategory
        into
            var_idf_subcategory,
            var_txt_subcategory
        from
            dat_subcategories
        where
            sys_status = true
            and idf_community = var_idf_community
            and idf_subcategory = var_idf_subcategory;

        outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_subcategory', var_idf_subcategory);
        outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_subcategory', var_txt_subcategory);

    end if;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;