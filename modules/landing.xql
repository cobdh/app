xquery version "3.1";

module namespace landing="https://data.cobdh.org/landing";

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

declare function landing:filter_collection($items){
    let $region := lower-case(request:get-cookie-value('collection'))
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
            return $item
};
