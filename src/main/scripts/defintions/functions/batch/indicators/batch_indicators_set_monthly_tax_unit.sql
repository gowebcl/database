drop function if exists batch_indicators_set_monthly_tax_unit;

create or replace function batch_indicators_set_monthly_tax_unit (
    incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_num_previous numeric;
    var_num_year numeric;
    var_obj_series json;
    var_txt_function text = 'batch_indicators_set_monthly_tax_unit';
    var_rec_month record;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_obj_series = environment_core_get_json_json (incoming_object, 'series');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    insert into srv_monthly_tax_unit_values (
        idf_monthly_tax_unit_value,
        num_value,
        num_year,
        num_month
    )
    select
        to_char ((json->>'fecha')::date, 'yyyymm')::numeric,
        (json->>'valor')::numeric "num_value",
        to_char ((json->>'fecha')::date, 'yyyy')::numeric,
        to_char ((json->>'fecha')::date, 'mm')::numeric
    from
        json_array_elements (var_obj_series) json
    order by
        (json->>'fecha')::date
    on conflict (idf_monthly_tax_unit_value)
    do update set
        num_value = excluded."num_value";

    select
        to_char ((json->>'fecha')::date, 'yyyy')::numeric
    into
        var_num_year
    from
        json_array_elements (var_obj_series) json
    order by
        (json->>'fecha')::date
    limit 1;

    for var_rec_month in
        select
            idf_monthly_tax_unit_value,
            to_char (to_date (idf_monthly_tax_unit_value::text, 'yyyymmdd') - '1 day'::interval, 'yyyymmdd')::numeric "num_previous",
            num_value
        from
            srv_monthly_tax_unit_values
        where
            num_year = var_num_year
        order by
            idf_monthly_tax_unit_value
    loop

        select
            num_value
        into
            var_num_previous
        from
            srv_monthly_tax_unit_values
        where
            idf_monthly_tax_unit_value = var_rec_month.num_previous;

        if (var_num_previous is null) then

            var_num_previous = var_rec_month.num_value;

        end if;

        update srv_monthly_tax_unit_values set
            num_absolute = var_rec_month.num_value - var_num_previous,
            num_variation = sign (var_rec_month.num_value - var_num_previous),
            num_percentage = round ((var_rec_month.num_value - var_num_previous) / var_num_previous * 100, 2)
        where
            idf_monthly_tax_unit_value = var_rec_month.idf_monthly_tax_unit_value;

    end loop;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;