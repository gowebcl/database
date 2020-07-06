drop function if exists environment_core_get_json_uuid;

create or replace function environment_core_get_json_uuid (
    in in_obj_array json,
    in in_txt_key text
)
returns text as $body$
declare
    var_idf_value uuid;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_idf_value;

    return var_idf_value::text;

end;
$body$ language plpgsql;