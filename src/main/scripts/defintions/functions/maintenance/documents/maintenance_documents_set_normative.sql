drop function if exists maintenance_documents_set_normative;

create or replace function maintenance_documents_set_normative (
    in incoming_object json,
    in incoming_xml xml
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_article numeric;
    var_idf_chapter numeric;
    var_idf_normative numeric;
    var_idf_paragraph numeric;
    var_idf_title numeric;
    var_txt_function text = 'maintenance_documents_set_normative';
    var_txt_id text;
    var_txt_modification text;
    var_txt_number text;
    var_txt_organism text;
    var_txt_promulgation text;
    var_txt_publication text;
    var_txt_rule text;
    var_txt_text text;
    var_txt_title text;
    var_txt_url text;
    var_txt_validity text;
    var_txt_version text;
    var_xml_article xml;
    var_xml_body xml;
    var_xml_chapter xml;
    var_xml_header xml;
    var_xml_paragraph xml;
    var_xml_title xml;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_normative = environment_core_get_next_sequence ('seq_normatives');
    var_sys_user = 0;

    select
        unnest (xpath ('./document/body', incoming_xml)),
        unnest (xpath ('./document/header', incoming_xml))
    into
        var_xml_body,
        var_xml_header;

    select
        unnest (xpath ('./header/id/text ()', var_xml_header)),
        unnest (xpath ('./header/modification/text ()', var_xml_header)),
        unnest (xpath ('./header/organism/text ()', var_xml_header)),
        unnest (xpath ('./header/promulgation/text ()', var_xml_header)),
        unnest (xpath ('./header/publication/text ()', var_xml_header)),
        unnest (xpath ('./header/rule/text ()', var_xml_header)),
        unnest (xpath ('./header/title/text ()', var_xml_header)),
        unnest (xpath ('./header/url/text ()', var_xml_header)),
        unnest (xpath ('./header/validity/text ()', var_xml_header)),
        unnest (xpath ('./header/version/text ()', var_xml_header))
    into
        var_txt_id,
        var_txt_modification,
        var_txt_organism,
        var_txt_promulgation,
        var_txt_publication,
        var_txt_rule,
        var_txt_title,
        var_txt_url,
        var_txt_validity,
        var_txt_version;

    insert into dat_normatives (
        idf_normative,
        txt_id,
        txt_modification,
        txt_organism,
        txt_promulgation,
        txt_publication,
        txt_rule,
        txt_title,
        txt_url,
        txt_validity,
        txt_version
    ) values (
        var_idf_normative,
        var_txt_id,
        var_txt_modification,
        var_txt_organism,
        var_txt_promulgation,
        var_txt_publication,
        var_txt_rule,
        var_txt_title,
        var_txt_url,
        var_txt_validity,
        var_txt_version
    );

    for var_xml_title in
        select
            unnest (xpath ('./body/title', var_xml_body))
    loop

        var_idf_title = environment_core_get_next_sequence ('seq_titles');

        select
            unnest (xpath ('./title/number/text ()', var_xml_title)),
            unnest (xpath ('./title/text/text ()', var_xml_title))
        into
            var_txt_number,
            var_txt_text;

        insert into dat_titles (
            idf_normative,
            idf_title,
            txt_number,
            txt_text
        ) values (
            var_idf_normative,
            var_idf_title,
            var_txt_number,
            var_txt_text
        );

        for var_xml_chapter in
            select
                unnest (xpath ('./title/chapter', var_xml_title))
        loop

            var_idf_chapter = environment_core_get_next_sequence ('seq_chapters');

            select
                unnest (xpath ('./chapter/number/text ()', var_xml_chapter)),
                unnest (xpath ('./chapter/text/text ()', var_xml_chapter))
            into
                var_txt_number,
                var_txt_text;

            insert into dat_chapters (
                idf_chapter,
                idf_normative,
                txt_number,
                txt_text
            ) values (
                var_idf_chapter,
                var_idf_normative,
                var_txt_number,
                var_txt_text
            );

            for var_xml_paragraph in
                select
                    unnest (xpath ('./chapter/paragraph', var_xml_chapter))
            loop

                var_idf_paragraph = environment_core_get_next_sequence ('seq_paragraphs');

                select
                    unnest (xpath ('./paragraph/number/text ()', var_xml_paragraph)),
                    unnest (xpath ('./paragraph/text/text ()', var_xml_paragraph))
                into
                    var_txt_number,
                    var_txt_text;

                insert into dat_paragraphs (
                    idf_paragraph,
                    txt_number,
                    txt_text,
                    idf_normative,
                    idf_chapter
                ) values (
                    var_idf_paragraph,
                    var_txt_number,
                    var_txt_text,
                    var_idf_normative,
                    var_idf_chapter
                );

                for var_xml_article in
                    select
                        unnest (xpath ('./paragraph/article', var_xml_paragraph))
                loop

                    var_idf_article = environment_core_get_next_sequence ('seq_articles');

                    select
                        unnest (xpath ('./article/number/text ()', var_xml_article)),
                        unnest (xpath ('./article/text/text ()', var_xml_article))
                    into
                        var_txt_number,
                        var_txt_text;

                    insert into dat_articles (
                        idf_article,
                        txt_number,
                        txt_text,
                        idf_normative,
                        idf_chapter,
                        idf_paragraph
                    ) values (
                        var_idf_article,
                        var_txt_number,
                        var_txt_text,
                        var_idf_normative,
                        var_idf_chapter,
                        var_idf_paragraph
                    );

                end loop;

            end loop;

        end loop;

    end loop;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end
$body$ language plpgsql;