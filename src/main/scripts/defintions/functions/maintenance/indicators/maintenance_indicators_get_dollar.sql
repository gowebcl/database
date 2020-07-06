drop function if exists maintenance_indicators_get_dollar;

create or replace function maintenance_indicators_get_dollar (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_days numeric;
    var_num_maximum numeric;
    var_num_minimum numeric;
    var_num_month numeric;
    var_num_year numeric;
    var_obj_value json;
    var_obj_values json;
    var_txt_function text;
    var_txt_month text;
    var_txt_year text;
    var_rec_value record;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_num_month = environment_core_get_json_numeric (incoming_object, 'num_month');
    var_num_year = environment_core_get_json_numeric (incoming_object, 'num_year');
    var_txt_function = 'maintenance_indicators_get_dollar';
    var_txt_month = lpad (environment_core_get_json_text (incoming_object, 'num_month'), 2, '0');
    var_txt_year = environment_core_get_json_text (incoming_object, 'num_year');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    select
        date_part ('days', date_trunc ('month', to_date (concat (var_txt_year, var_txt_month), 'yyyymm')) + '1 month'::interval - '1 day'::interval),
        max (num_value),
        min (num_value)
    into
        var_num_days,
        var_num_maximum,
        var_num_minimum
    from
        srv_dollar_values
    where
        num_year = var_num_year
        and num_month = var_num_month;

    for var_rec_value in
        select
            num_day,
            num_type,
            num_value,
            num_variation,
            num_absolute,
            num_percentage,
            var_txt_year || '-' || var_txt_month || '-' || lpad (num_day::text, 2, '0') "txt_date"
        from
            srv_dollar_values
        where
            num_year = var_num_year
            and num_month = var_num_month
        order by
            idf_dollar_value
    loop

        select
            array_to_json (
                array_agg (returned)
            )
        into
            var_obj_value
        from (
            select
                var_rec_value.num_day,
                var_rec_value.num_type,
                var_rec_value.num_value,
                var_rec_value.num_variation,
                var_rec_value.num_absolute,
                var_rec_value.num_percentage,
                var_rec_value.txt_date
        ) returned;

        var_obj_values = environment_core_set_json_json (var_obj_values, 'obj_value', var_obj_value);

    end loop;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_days', var_num_days);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_maximum', var_num_maximum);
    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_minimum', var_num_minimum);
    outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_values', var_obj_values);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;