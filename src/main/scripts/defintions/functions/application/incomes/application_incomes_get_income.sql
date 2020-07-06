drop function if exists application_incomes_get_income;

create or replace function application_incomes_get_income (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_txt_function text = 'application_incomes_get_income';
    var_rec_unit record;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    for var_rec_unit in
        select
            idf_unit,
            txt_unit
        from
            dat_units
        where
            sys_status = true
            and idf_community = var_idf_community
        order by
            txt_unit
    loop

        select
            array_to_json (
                array_agg (returned)
            )
        into
            var_obj_category
        from (
            select
                var_rec_category.idf_category,
                var_rec_category.txt_category
        ) returned;


    end loop;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;