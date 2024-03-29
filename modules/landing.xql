xquery version "3.1";

module namespace landing="https://cobdh.org/landing";

import module namespace request = "http://exist-db.org/xquery/request";

import module namespace response = "http://exist-db.org/xquery/response";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace templates="http://exist-db.org/xquery/templates";

declare
    %templates:wrap
function landing:region_select($node as node(), $model as map(*)){
    let $age := xs:dayTimeDuration("PT24H")
    let $region := request:get-parameter("collection", "")
    (: TODO: REMOVE INVALID LANGUAGES :)
    let $collection := $region
    (: TODO: ENABLE BEFORE RELEASE :)
    let $secure := false()
    return
        if ($collection eq "") then
            ()
        else
            response:set-cookie(
                "collection",
                $collection,
                $age,
                $secure
            )
};

declare function landing:select_category($items){
    let $region := lower-case(request:get-cookie-value('collection'))
    (: Wordaround if cookie is not setable as a result of browser settings. :)
    let $region := if ($region) then $region
                   else request:get-parameter('collection', '')
    let $category := if ($region eq 'ar') then 'ARMENIA'
    else (
        if ($region eq 'ge') then 'GEORGIA' else ''
    )
    return
        if ($region eq '' or $region eq 'all') then
            $items
        else
            for $item in $items
            where $item //tei:category[@xml:id eq $category]
            (:Select Category is not stable, to ensure ordering we have to
            order it. Investiate to make it stable and remove the hack. :)
            (:TODO: REMOVE ORDER BY HACK :)
            order by $item//tei:date descending
            return $item
};
