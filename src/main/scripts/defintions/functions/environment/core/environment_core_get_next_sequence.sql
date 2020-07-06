drop function if exists environment_core_get_next_sequence;

create or replace function environment_core_get_next_sequence (
    in in_txt_key text
)
returns numeric as $body$
begin

    return nextval (in_txt_key);

end;
$body$ language plpgsql;