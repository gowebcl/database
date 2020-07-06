drop function if exists environment_core_get_last_sequence;

create or replace function environment_core_get_last_sequence (
    in in_txt_key text
)
returns numeric as $body$
declare
    var_num_sequence numeric;
begin

    select
        setval (in_txt_key, nextval (in_txt_key) - 1)
    into
        var_num_sequence;

    return var_num_sequence;

end;
$body$ language plpgsql;