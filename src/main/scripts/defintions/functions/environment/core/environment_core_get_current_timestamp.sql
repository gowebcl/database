drop function if exists environment_core_get_current_timestamp;

create or replace function environment_core_get_current_timestamp (
)
returns timestamp as $body$
begin

    return current_timestamp at time zone 'brt';

end;
$body$ language plpgsql;