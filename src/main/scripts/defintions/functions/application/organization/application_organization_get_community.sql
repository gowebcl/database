drop function if exists application_organization_get_community;

create or replace function application_organization_get_community (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_num_communities numeric;
    var_obj_communities json;
    var_txt_commune text;
    var_txt_community text;
    var_txt_condominium_type text;
    var_txt_function text = 'application_organization_get_community';
    var_txt_province text;
    var_txt_region text;
    var_txt_unique_rol text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    if (var_idf_community is null) then

        select
            count (*)
        into
            var_num_communities
        from
            dat_communities
        where
            sys_status = true;

        outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_communities', var_num_communities);
        outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_communities', var_obj_communities);

    else

        select
            com.idf_community,
            com.txt_community,
            com.num_unique_rol || '-' || com.txt_check_digit "txt_unique_rol",
            sct.txt_condominium,
            srg.txt_region,
            spv.txt_province,
            scm.txt_commune
        into
            var_txt_community,
            var_txt_unique_rol,
            var_txt_condominium_type,
            var_txt_region,
            var_txt_province,
            var_txt_commune
        from
            dat_communities com,
            srv_condominiums sct,
            srv_regions srg,
            srv_provinces spv,
            srv_communes scm
        where
            com.sys_status = true
            and com.num_unique_rol <> 0
            and com.idf_community = var_idf_community
            and sct.idf_condominium = com.idf_condominium
            and srg.idf_region = com.idf_region
            and spv.idf_province = com.idf_province
            and scm.idf_commune = com.idf_commune;

    end if;

/*
select
environment_core_get_random_numeric (2)
into
var_num_ownerships;

select
array_to_json (
  array_agg (returned)
)
into
var_obj_ownerships
from (
select
  spt.txt_property,
  count (*) "num_ownership",
  sum (ows.num_aliquot)"num_aliquot"
from
  dat_ownerships ows,
  srv_properties spt
where
  ows.sys_status = true
  and ows.idf_community = var_idf_community
  and spt.idf_property = ows.idf_property
group by
  spt.txt_property
order by
  spt.txt_property
) returned;
*/

    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_community', var_txt_community);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_condominium_type', var_txt_condominium_type);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_unique_rol', var_txt_unique_rol);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_region', var_txt_region);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_province', var_txt_province);
    outgoing_object = environment_core_set_json_text (outgoing_object, 'txt_commune', var_txt_commune);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;