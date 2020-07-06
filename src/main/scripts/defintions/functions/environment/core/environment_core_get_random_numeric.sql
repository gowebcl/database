drop function if exists environment_core_get_random_numeric;

create or replace function environment_core_get_random_numeric (
    in in_num_length numeric
)
returns numeric as $body$
declare
    var_num_offset numeric;
    var_txt_chars text[] := '{0,1,2,3,4,5,6,7,8,9}';
    var_txt_result text := '';
begin

    for var_num_offset in
        1 .. in_num_length
    loop

        var_txt_result := var_txt_result || var_txt_chars [1 + random () * (array_length (var_txt_chars, 1) - 1)];

    end loop;

    return var_txt_result::numeric;

end;
$body$ language plpgsql;