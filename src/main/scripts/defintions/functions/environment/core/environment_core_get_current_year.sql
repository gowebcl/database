drop function if exists environment_core_get_current_year;

create or replace function environment_core_get_current_year (
)
returns numeric as $body$
begin

    return to_char (environment_core_get_current_timestamp (), 'yyyy')::numeric;

end;
$body$ language plpgsql;