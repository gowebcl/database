drop function if exists application_organization_set_community;

create or replace function application_organization_set_community (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_category numeric;
    var_idf_community numeric;
    var_idf_commune numeric;
    var_idf_condominium numeric;
    var_idf_parameter numeric;
    var_idf_province numeric;
    var_idf_region numeric;
    var_idf_subcategory numeric;
    var_idf_type numeric;
    var_num_communities numeric;
    var_num_postal_code numeric;
    var_num_unique_rol numeric;
    var_rec_category record;
    var_rec_parameter record;
    var_rec_subcategory record;
    var_rec_type record;
    var_txt_address text;
    var_txt_check_digit text;
    var_txt_community text;
    var_txt_email text;
    var_txt_function text = 'application_organization_set_community';
    var_txt_location text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_next_sequence ('seq_communities');
    var_idf_commune = environment_core_get_json_numeric (incoming_object, 'idf_commune');
    var_idf_condominium = environment_core_get_json_numeric (incoming_object, 'idf_condominium');
    var_idf_province = environment_core_get_json_numeric (incoming_object, 'idf_province');
    var_idf_region = environment_core_get_json_numeric (incoming_object, 'idf_region');
    var_num_postal_code = environment_core_get_json_numeric (incoming_object, 'num_postal_code');
    var_num_unique_rol = environment_core_get_json_numeric (incoming_object, 'num_unique_rol');
    var_txt_address = initcap (environment_core_get_json_text (incoming_object, 'txt_address'));
    var_txt_check_digit = initcap (environment_core_get_json_text (incoming_object, 'txt_check_digit'));
    var_txt_community = initcap (environment_core_get_json_text (incoming_object, 'txt_community'));
    var_txt_email = lower (environment_core_get_json_text (incoming_object, 'txt_email'));
    var_txt_location = environment_core_get_json_text (incoming_object, 'txt_location');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    select
        count (*)
    into
        var_num_communities
    from
        dat_communities
    where
        sys_status = true
        and num_unique_rol = var_num_unique_rol;

    if (var_num_communities <> 0) then

        return environment_core_get_function_result (var_sys_user, var_txt_function, 11004, incoming_object, outgoing_object);

    end if;

    insert into dat_communities (
        sys_user,
        idf_commune,
        idf_community,
        idf_condominium,
        idf_province,
        idf_region,
        num_postal_code,
        num_unique_rol,
        txt_address,
        txt_check_digit,
        txt_community,
        txt_email,
        txt_location
    ) values (
        var_sys_user,
        var_idf_commune,
        var_idf_community,
        var_idf_condominium,
        var_idf_province,
        var_idf_region,
        var_num_postal_code,
        var_num_unique_rol,
        var_txt_address,
        var_txt_check_digit,
        var_txt_community,
        var_txt_email,
        var_txt_location
    );

    for var_rec_parameter in
        select
            txt_key,
            txt_value
        from
            srv_parameters
        order by
            idf_parameter
    loop

        var_idf_parameter = environment_core_get_next_sequence ('seq_parameters');

        insert into dat_parameters (
            sys_user,
            idf_parameter,
            idf_community,
            txt_key,
            txt_value
        ) values (
            var_sys_user,
            var_idf_parameter,
            var_idf_community,
            var_rec_parameter.txt_key,
            var_rec_parameter.txt_value
        );

    end loop;

/*
insert into dat_profiles (
sys_user,
idf_community,
idf_profile,
txt_profile
)
select
var_sys_user,
var_idf_community,
environment_core_get_next_sequence ('seq_profile'),
txt_profile
from
srv_profiles
where
idf_profile > 0
order by
idf_profile;
*/

    for var_rec_category in
        select
            idf_category,
            txt_category
        from
            srv_categories
        order by
            idf_category
    loop

        var_idf_category = environment_core_get_next_sequence ('seq_categories');

        insert into dat_categories (
            sys_user,
            idf_category,
            idf_community,
            txt_category
        ) values (
            var_sys_user,
            var_idf_category,
            var_idf_community,
            var_rec_category.txt_category
        );

        for var_rec_subcategory in
            select
                idf_subcategory,
                txt_subcategory
            from
                srv_subcategories
            where
                idf_category = var_rec_category.idf_category
            order by
                idf_subcategory
        loop

            var_idf_subcategory = environment_core_get_next_sequence ('seq_subcategories');

            insert into dat_subcategories (
                sys_user,
                idf_category,
                idf_community,
                idf_subcategory,
                txt_subcategory
            ) values (
                var_sys_user,
                var_rec_category.idf_category,
                var_idf_community,
                var_idf_subcategory,
                var_rec_subcategory.txt_subcategory
            );

        end loop;

    end loop;

    for var_rec_type in
        select
            idf_type,
            txt_type
        from
            srv_types
        order by
            idf_type
    loop

        var_idf_type = environment_core_get_next_sequence ('seq_types');

        insert into dat_types (
            sys_user,
            idf_community,
            idf_type,
            txt_type
        ) values (
            var_sys_user,
            var_idf_community,
            var_idf_type,
            var_rec_type.txt_type
        );

    end loop;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'idf_community', var_idf_community);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;