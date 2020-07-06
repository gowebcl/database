drop function if exists environment_core_get_date_dd;

create or replace function environment_core_get_date_dd (
    in in_txt_date text
)
returns numeric as $body$
begin

    return to_char (in_txt_date::date, 'dd')::numeric;

end;
$body$ language plpgsql;