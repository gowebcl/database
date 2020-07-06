drop function if exists environment_core_get_result_success;

create or replace function environment_core_get_result_success ()
returns numeric as $body$
begin

    return 0;

end;
$body$ language plpgsql;