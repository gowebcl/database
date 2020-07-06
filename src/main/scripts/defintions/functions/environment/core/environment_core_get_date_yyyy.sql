drop function if exists environment_core_get_date_yyyy;

create or replace function environment_core_get_date_yyyy (
    in in_txt_date text
)
returns numeric as $body$
begin

    return to_char (in_txt_date::date, 'yyyy')::numeric;

end;
$body$ language plpgsql;