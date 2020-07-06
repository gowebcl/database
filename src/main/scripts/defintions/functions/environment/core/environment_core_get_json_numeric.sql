drop function if exists environment_core_get_json_numeric;

create or replace function environment_core_get_json_numeric (
    in in_obj_array json,
    in in_txt_key text
)
returns numeric as $body$
declare
    var_num_value numeric;
begin

    select
        trim (in_obj_array::json->>in_txt_key)
    into
        var_num_value;

    return var_num_value;

end;
$body$ language plpgsql;