xquery version "3.0";

module namespace app="https://data.cobdh.org/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

declare namespace request="http://exist-db.org/xquery/request";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated).
 : The function has to take 2 default parameters. Additional parameters are automatically mapped to
 : any matching request or function parameter.
 :
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)){
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};

declare function app:href($node as node(), $model as map(*), $text as xs:string, $path as xs:string){
    (: TODO CONFIGURABLE LATER :)
    <a href="/exist/apps/cobdh-data{$path}">{$text}</a>
};

declare function app:abspath($path as xs:string){
    let $result := concat("/exist/apps/cobdh-data/", $path)
    return
        $result
};

(:~ Determine resource based on passed url.
 : For example: https://data.cobdh.org/bibl/123 the resource is 123.
:)
declare function app:determine_resource($node as node(), $model as map(*)){
    let $resource := tokenize(request:get-uri(), '/')[position() = last()]
    return
        (: Store in `model` to use in further template procesing. :)
        map {"selected" : $resource }
};
