drop function if exists application_organization_set_ownership;

create or replace function application_organization_set_ownership (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_boo_unit boolean;
    var_idf_community numeric;
    var_idf_ownership numeric;
    var_idf_property numeric;
    var_idf_unit numeric;
    var_num_aliquot numeric;
    var_num_floor numeric;
    var_num_ownerships numeric;
    var_txt_function text = 'application_organization_set_ownership';
    var_txt_ownership text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_boo_unit = environment_core_get_json_boolean (incoming_object, 'boo_unit');
    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_idf_ownership = environment_core_get_next_sequence ('seq_ownerships');
    var_idf_property = environment_core_get_json_numeric (incoming_object, 'idf_property');
    var_num_aliquot = environment_core_get_json_numeric (incoming_object, 'num_aliquot');
    var_num_floor = environment_core_get_json_numeric (incoming_object, 'num_floor');
    var_txt_ownership = environment_core_get_json_text (incoming_object, 'txt_ownership');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    select
        count (*)
    into
        var_num_ownerships
    from
        dat_ownerships
    where
        sys_status = true
        and idf_community = var_idf_community
        and idf_property = var_idf_property
        and txt_ownership = var_txt_ownership;

    if (var_num_ownerships > 0) then

        return environment_core_get_function_result (var_sys_user, var_txt_function, 11007, incoming_object, outgoing_object);

    end if;

    insert into dat_ownerships (
        idf_community,
        idf_ownership,
        txt_ownership,
        idf_property,
        num_floor,
        num_aliquot,
        sys_user
    ) values (
        var_idf_community,
        var_idf_ownership,
        var_txt_ownership,
        var_idf_property,
        var_num_floor,
        var_num_aliquot,
        var_sys_user
    );

    if (var_boo_unit is true) then

        var_idf_unit = environment_core_get_next_sequence ('seq_units');

        insert into dat_units (
            idf_community,
            idf_unit,
            num_aliquot,
            txt_unit,
            sys_user
        ) values (
            var_idf_community,
            var_idf_unit,
            var_num_aliquot,
            var_txt_ownership,
            var_sys_user
        );

    end if;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_ownership', var_idf_ownership);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;