xquery version "3.1";

module namespace landing="https://data.cobdh.org/landing";

import module namespace request = "http://exist-db.org/xquery/request";

import module namespace response = "http://exist-db.org/xquery/response";

(: Namespaces :)
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
