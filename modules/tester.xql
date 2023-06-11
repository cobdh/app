xquery version "3.0";

module namespace tester="https://cobdh.org/tester";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";

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
