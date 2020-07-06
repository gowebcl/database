drop function if exists environment_core_get_date_mm;

create or replace function environment_core_get_date_mm (
    in in_txt_date text
)
returns numeric as $body$
begin

    return to_char (in_txt_date::date, 'mm')::numeric;

end;
$body$ language plpgsql;