drop function if exists environment_core_get_json_json;

create or replace function environment_core_get_json_json (
    in in_obj_array json,
    in in_txt_key text
)
returns json as $body$
declare
    var_txt_value json;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_txt_value;

    return jsonb_pretty (var_txt_value::jsonb);

end;
$body$ language plpgsql;