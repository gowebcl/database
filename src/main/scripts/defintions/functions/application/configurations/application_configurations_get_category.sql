drop function if exists application_configurations_get_category;

create or replace function application_configurations_get_category (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_category numeric;
    var_idf_community numeric;
    var_num_categories numeric;
    var_obj_categories json;
    var_txt_category text;
    var_txt_function text = 'application_configurations_get_category';
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_category = environment_core_get_json_numeric (incoming_object, 'idf_category');
    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    if (var_idf_category is null) then

        select
            count (*)
        into
            var_num_categories
        from
            dat_categories
        where
            sys_status = true
            and idf_community = var_idf_community;

        select
            array_to_json (
                array_agg (returned)
            )
        into
            var_obj_categories
        from (
            select
                idf_category,
                txt_category
            from
                dat_categories
            where
                sys_status = true
                and idf_community = var_idf_community
        ) returned;

        outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_categories', var_num_categories);
        outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_categories', var_obj_categories);

    else

        select
            idf_category,
            txt_category
        into
            var_idf_category,
            var_txt_category
        from
            dat_categories
        where
            sys_status = true
            and idf_community = var_idf_community
            and idf_category = var_idf_category;

        outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_category', var_idf_category);
        outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_category', var_txt_category);

    end if;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;