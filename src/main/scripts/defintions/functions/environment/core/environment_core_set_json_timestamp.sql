drop function if exists environment_core_set_json_timestamp;

create or replace function environment_core_set_json_timestamp (
    in in_obj_array json,
    in in_txt_key text,
    in in_txt_value timestamp
)
returns json as $body$
declare
    var_obj_array json;
begin

    var_obj_array = json_build_object (in_txt_key, in_txt_value);

    if (in_obj_array is not null) then

        select
            in_obj_array::jsonb || var_obj_array::jsonb
        into
            var_obj_array;

    end if;

    return var_obj_array;

end;
$body$ language plpgsql;