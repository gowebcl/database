drop function if exists environment_core_get_json_text;

create or replace function environment_core_get_json_text (
    in in_obj_array json,
    in in_txt_key text
)
returns text as $body$
declare
    var_txt_value text;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_txt_value;

    return var_txt_value;

end;
$body$ language plpgsql;