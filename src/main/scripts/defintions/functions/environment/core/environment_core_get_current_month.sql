drop function if exists environment_core_get_current_month;

create or replace function environment_core_get_current_month (
)
returns numeric as $body$
begin

    return to_char (environment_core_get_current_timestamp (), 'mm')::numeric;

end;
$body$ language plpgsql;