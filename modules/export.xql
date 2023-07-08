xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="https://cobdh.org/config" at "config.xqm";

let $format := request:get-parameter('format', 'tei')
let $collection := request:get-parameter('collection', 'persons')
let $resource := request:get-parameter('resource', '')
(: Convert base64 :)
let $resource := xmldb:decode($resource)
let $source := concat($config:data-root, '/', $collection)
let $selected := if ($collection eq 'templates')
    then
        doc(concat($source, '/', $resource, '.xml'))
    else
        collection($source)//(tei:biblFull|tei:biblStruct|tei:person)[@xml:id eq $resource]

return
    if (empty($selected)) then
    (
        response:set-header("Content-Type", "text/plain; charset=utf-8"),
        concat("Resource not Found!",
            " Collection: ",
            $collection,
            " Resource: ",
            $resource
        )
    )
    else
    (
        response:set-header("Content-Type", "text/plain; charset=utf-8"),
        root($selected)
    )
