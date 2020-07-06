drop function if exists environment_core_set_json_empty;

create or replace function environment_core_set_json_empty ()
returns json as $body$
begin

    return '[]';

end;
$body$ language plpgsql;