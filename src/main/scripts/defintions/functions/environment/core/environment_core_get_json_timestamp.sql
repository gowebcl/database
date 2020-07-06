drop function if exists environment_core_get_json_timestamp;

create or replace function environment_core_get_json_timestamp (
    in in_obj_array json,
    in in_txt_key text
)
returns timestamp as $body$
declare
    var_txt_value text;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_txt_value;

    return var_txt_value::timestamp;

end;
$body$ language plpgsql;