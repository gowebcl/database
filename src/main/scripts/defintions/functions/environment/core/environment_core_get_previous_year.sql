drop function if exists environment_core_get_previous_year;

create or replace function environment_core_get_previous_year (
    in in_num_month numeric,
    in in_num_year numeric,
    in in_num_offset numeric
)
returns numeric as $body$
declare
    var_tim_offset timestamp;
begin

    if (in_num_month is null or in_num_year is null) then

        select
            to_date (environment_core_get_current_year ()::text || environment_core_get_current_month ()::text, 'yyyymm')
        into
            var_tim_offset;

    else

        select
            to_date (in_num_year::text || in_num_month::text, 'yyyymm')
        into
            var_tim_offset;

    end if;

    return to_char (var_tim_offset - make_interval (0, in_num_offset::integer), 'yyyy')::numeric;

end;
$body$ language plpgsql;