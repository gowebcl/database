drop function if exists application_organization_set_ownerships;

create or replace function application_organization_set_ownerships (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_obj_ownership json;
    var_obj_ownerships json;
    var_txt_function text = 'application_organization_set_ownerships';
    var_rec_ownership record;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_obj_ownerships = environment_core_get_json_json (incoming_object, 'obj_ownerships');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    for var_rec_ownership in
        select
            json->>'txt_ownership' "txt_ownership",
            (json->>'idf_property')::numeric "idf_property",
            (json->>'num_floor')::numeric "num_floor",
            (json->>'num_aliquot')::numeric "num_aliquot",
            (json->>'boo_unit')::boolean "boo_unit"
        from
            json_array_elements (var_obj_ownerships) json
        order by
            (json->>'num_ownership_type')::numeric,
            json->>'txt_ownership'
    loop

        select
            array_to_json (
                array_agg (returned)
            ) -> 0
        into
            var_obj_ownership
        from (
            select
                var_sys_user "sys_user",
                var_idf_community "idf_community",
                var_rec_ownership.txt_ownership,
                var_rec_ownership.idf_property,
                var_rec_ownership.num_floor,
                var_rec_ownership.num_aliquot,
                var_rec_ownership.boo_unit
        ) returned;

        outgoing_object = application_organization_set_ownership (var_obj_ownership);

    end loop;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;