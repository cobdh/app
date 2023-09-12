xquery version "3.0";

module namespace app="https://cobdh.org/app";

import module namespace templates="http://exist-db.org/xquery/templates";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace page="https://cobdh.org/page" at "lib/paging.xqm";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare namespace request="http://exist-db.org/xquery/request";

(: Global Variables:)
declare variable $app:start {local:get_int('start', 0)};

declare variable $app:perpage {local:get_int('perpage', 25)};

declare variable $app:alpha {request:get-parameter('alpha', '')};

(:~ Use demo parameter to develop new functionalities. Enable demo mode with
 : ?demo=1
:)
declare function app:href($node as node(), $model as map(*),
    $text as xs:string,
    $path as xs:string,
    $demo as xs:integer*
){
    let $visible := empty($demo) or $config:demo
    return
        if($visible) then
            (: TODO CONFIGURABLE LATER :)
            <a href="{$config:web-root}{$path}" class="nav-link">{$text}</a>
        else
            ()
};

declare
    (:~ TODO: ENABLE LATER
    %test:arg("path", "bibl/1234")
    %test:assertEquals('/exist/apps/cobdh/bibl/1234')
    :)
function app:abspath($path as xs:string){
    let $result := concat($config:web-root, $path)
    return
        $result
};

(:~ Determine resource based on passed url.
 : For example: https://cobdh.org/bibl/123 the resource is 123.
:)
declare function app:determine_resource($node as node(), $model as map(*)){
    let $parsed := app:parse_resource_url(request:get-uri())
    let $resource := $parsed[2]
    let $type := if (empty($parsed[3])) then 'html' else $parsed[3]
    let $content := ()
    return
        (: Store in `model` to use in further template procesing. :)
        map{
            "selected" : $resource,
            "content" : $content,
            "type" : $type
        }
};

declare
    (:Access TEI-Resource in bibl-Collection:)
    %test:arg("url", "exist/apps/cobdh/bibl/Hovhanessian2013.tei")
    %test:assertEquals('bibl', 'Hovhanessian2013', 'tei')

    (:No special resource format is defined:)
    %test:arg("url", "exist/apps/cobdh/persons/Helmutus")
    %test:assertEquals('persons', 'Helmutus')

    (:Allow simple index access:)
    %test:arg("url", "https://cobdh.org/persons/123")
    %test:assertEquals('persons', '123')

    (:Non-Data-Collection-page:)
    %test:arg("url", "exist/apps/cobdh/about")
    %test:assertEmpty

    (:Non-Unicode url:)
    %test:arg("url", "cobdh/persons/MaclerFr%C3%A9d%C3%A9ric")
    %test:assertEquals('persons', 'MaclerFrédéric')
function app:parse_resource_url($url){
    let $url := xmldb:decode($url)
    let $parsed := analyze-string(
        $url,
        "/(bibl|persons|editors)/([\w\d_]+)(.(tei))?$"
    )
    let $collection := $parsed//fn:group[@nr=1]//text()
    let $resource := $parsed//fn:group[@nr=2]//text()
    let $type := $parsed//fn:group[@nr=4]//text()
    return
        ($collection, $resource, $type)
};

declare function app:get_parameter($node as node(), $model as map(*), $parameter as xs:string){
    request:get-parameter($parameter, '')
};

(:~
 : Display paging functions in html templates.
:)
declare %templates:wrap function app:pageination(
    $node as node()*,
    $model as map(*),
    $hits,
    $collection as xs:string?
){
    page:pages(
        $hits,
        $collection,
        $app:start,
        $app:perpage
    )
};

declare
    %templates:wrap
function app:view_template($node as node(), $model as map(*), $template as xs:string){
    let $root := $config:app-root
    let $path := concat('data/templates/', $template, '.xml')
    let $src := concat($root, '/',$path)
    let $data := doc($src)
    return
        <div>
            <h4><a href="{app:abspath(concat('/templates/', $template))}" target="_blank">{concat('templates/', $template)}</a></h4>
            <textarea lang="xml" class="viewtemplate_textarea">{$data}</textarea>
        </div>
};

declare function local:get_int($var as xs:string, $default as xs:integer){
    try{
        xs:integer(request:get-parameter($var, $default))
    }catch *{
        $default
    }
};
