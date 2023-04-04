xquery version "3.0";

declare namespace xi = "http://www.w3.org/2001/XInclude";

let $format := request:get-parameter('format', 'tei')
let $collection := request:get-parameter('collection', 'persons')
let $resource := '1'

return
    (
        response:set-header("Content-Type", "text/plain; charset=utf-8"),
        <xi:include href="/db/apps/cobdh-data/data/{$collection}/{$resource}.xml"/>
    )
