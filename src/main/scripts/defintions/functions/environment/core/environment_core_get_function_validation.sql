drop function if exists environment_core_get_function_validation;

create or replace function environment_core_get_function_validation (
    in incoming_object json
)
returns void as $body$
declare
    var_sys_user numeric;
begin

    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    if (var_sys_user is null) then

        raise exception data_exception;

    end if;

end;
$body$ language plpgsql;