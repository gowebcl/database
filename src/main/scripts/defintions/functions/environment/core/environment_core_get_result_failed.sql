drop function if exists environment_core_get_result_failed;

create or replace function environment_core_get_result_failed ()
returns numeric as $body$
begin

    return 2;

end;
$body$ language plpgsql;