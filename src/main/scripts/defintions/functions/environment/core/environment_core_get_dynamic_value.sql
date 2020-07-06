drop function if exists environment_core_get_dynamic_value;

create or replace function environment_core_get_dynamic_value (
    in in_txt_value text
)
returns text as $body$
declare
    var_txt_value text;
    var_txt_sequence text;
begin

    var_txt_value = trim (in_txt_value);

    select
        var_txt_value
    into
        var_txt_sequence
    where
        var_txt_value like '<![SEQUENCE[%'
        and var_txt_value like '%]]>';

    if (var_txt_sequence is not null) then

        var_txt_sequence = substring (var_txt_sequence, length ('<![SEQUENCE[') + 1);
        var_txt_sequence = substring (var_txt_sequence, 0, length (var_txt_sequence) - length (']]>') + 1);

        select
            nextval (var_txt_sequence)
        into
            var_txt_value;

    else

        var_txt_value = '''' || var_txt_value;
        var_txt_value = var_txt_value || '''';

    end if;

    return var_txt_value;

end;
$body$ language plpgsql;