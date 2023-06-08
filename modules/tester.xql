xquery version "3.0";

module namespace tester="https://cobdh.org/tester";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";

import module namespace templates="http://exist-db.org/xquery/templates";

declare function tester:error-handler-test($node as node(), $model as map(*), $number as xs:string?){
    if (exists($number)) then
        xs:int($number)
    else
        ()
};

declare function tester:link-to-home($node as node(), $model as map(*)){
    <a href="{request:get-context-path()}/">{
        $node/@* except $node/@href,
        $node/node()
    }</a>
};

declare function tester:run-tests($node as node(), $model as map(*)){
    for $path in (
        "app.xql",
        "tests/sample.xql"
    )
        let $todo := inspect:module-functions(xs:anyURI($path))
        let $results := test:suite($todo)
        return
            test:to-html($results)
};

declare function tester:display-source($node as node(), $model as map(*), $lang as xs:string?, $type as xs:string?){
    let $source := replace($node/string(), "^\s*(.*)\s*$", "$1")
    let $expanded := replace($source, "@@path", $config:app-root)
    let $eXideLink := templates:link-to-app("http://exist-db.org/apps/eXide", "index.html?snip=" || encode-for-uri($expanded))
    return
        <div xmlns="http://www.w3.org/1999/xhtml" class="source">
            <div class="code" data-language="{if ($lang) then $lang else 'xquery'}">{ $expanded }</div>
            <div class="toolbar">
                <div class="btn-group">
                <a class="btn btn-secondary run" href="#" data-type="{if ($type) then $type else 'xml'}">
                    <i class="glyphicon glyphicon-play"/> Run</a>
                <a class="btn btn-secondary eXide-open" href="{$eXideLink}" target="eXide"
                    data-exide-create="{$expanded}"
                    title="Opens the code in eXide in new tab or existing tab if it is already open.">
                    <i class="glyphicon glyphicon-edit"/> Edit</a>
                </div>
                <img class="load-indicator" src="resources/images/ajax-loader.gif"/>
                <div class="output"></div>
            </div>
        </div>
};
