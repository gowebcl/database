drop function if exists environment_core_get_function_result;

create or replace function environment_core_get_function_result (
    in in_sys_user numeric,
    in in_txt_function text,
    in in_idf_exception numeric,
    in in_obj_incoming json,
    in in_obj_outgoing json
)
returns json as $body$
declare
    var_boo_defined boolean;
    var_idf_trace numeric;
    var_obj_array json;
var_txt_message text;
var_txt_reason text;
begin
/*
select
1
--txt_exception,
--txt_reason
into
var_boo_defined
--var_txt_message,
--var_txt_reason
from
log_exceptions
where
idf_exception = in_idf_exception;

if (var_txt_message is null) then

select
0
--txt_exception,
--txt_reason
into
var_boo_defined
--var_txt_message,
--var_txt_reason
from
log_exceptions
where
idf_exception = 1;

end if;
*/
--var_obj_array = json_build_object ('num_result', in_idf_exception, 'txt_message', var_txt_message, 'txt_reason', var_txt_reason);
    var_obj_array = json_build_object ('sys_result', in_idf_exception);
    var_obj_array = json_build_object ('status', var_obj_array);

    if (in_obj_outgoing is not null) then

        in_obj_outgoing = json_build_object ('data', in_obj_outgoing);

        select
            in_obj_outgoing::jsonb || var_obj_array::jsonb
        into
            var_obj_array;

    end if;

    var_idf_trace = environment_core_get_next_sequence ('seq_traces');

    insert into log_traces (
        sys_user,
        boo_defined,
        idf_exception,
        idf_trace,
        obj_incoming,
        obj_outgoing,
        txt_function,
        uid_trace
    ) values (
        in_sys_user,
        var_boo_defined,
        in_idf_exception,
        var_idf_trace,
        in_obj_incoming,
        in_obj_outgoing,
        in_txt_function,
        uuid_generate_v4 ()
    );

    return var_obj_array;

end;
$body$ language plpgsql;