drop function if exists environment_core_get_json_boolean;

create or replace function environment_core_get_json_boolean (
    in in_obj_array json,
    in in_txt_key text
)
returns boolean as $body$
declare
    var_boo_value boolean;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_boo_value;

    return var_boo_value;

end;
$body$ language plpgsql;