drop function if exists maintenance_indicators_get_monthly_tax_unit;

create or replace function maintenance_indicators_get_monthly_tax_unit (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_maximum numeric;
    var_num_minimum numeric;
    var_num_months numeric;
    var_num_year numeric;
    var_obj_values json;
    var_txt_function text;
    var_txt_year text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_num_year = environment_core_get_json_numeric (incoming_object, 'num_year');
    var_txt_function = 'maintenance_indicators_get_monthly_tax_unit';
    var_txt_year = environment_core_get_json_text (incoming_object, 'num_year');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    select
        12,
        max (num_value),
        min (num_value)
    into
        var_num_months,
        var_num_maximum,
        var_num_minimum
    from
        srv_monthly_tax_unit_values
    where
        num_year = var_num_year;

    select
        array_to_json (
            array_agg (returned)
        )
    into
        var_obj_values
    from (
        select
            num_value,
            num_variation,
            num_absolute,
            num_percentage
        from
            srv_monthly_tax_unit_values
        where
            num_year = var_num_year
        order by
            idf_monthly_tax_unit_value
    ) returned;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_months', var_num_months);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_maximum', var_num_maximum);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_minimum', var_num_minimum);
    outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_values', var_obj_values);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;