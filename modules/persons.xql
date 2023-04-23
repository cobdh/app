xquery version "3.0";

module namespace persons="https://data.cobdh.org/persons";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace templates="http://exist-db.org/xquery/templates" at "template.xql";

import module namespace bibl="https://data.cobdh.org/bibl" at "bibl.xql";

import module namespace app="https://data.cobdh.org/app" at "app.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Display list of persons. Use pagination to display huge amount of data. :)
declare function persons:index($node as node(), $model as map(*)){
    let $start := $app:start
    let $perpage := $app:perpage
    let $persons := persons:list-items()
    (: Select current data for pagination :)
    let $persons := subsequence($persons, $start, $perpage)
    let $persons := <tei:listPerson>{$persons}</tei:listPerson>
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        transform:transform($persons, $xsl, ())
};

declare function persons:view-item($node as node(), $model as map(*), $index as xs:string){
    let $data := collection($config:data-persons)//tei:person[@xml:id eq $index]
    (: select root node to render header information :)
    let $data := root($data)
    (: select template :)
    let $xsl := config:resolve("views/persons/view-item.xsl")
    return
        transform:transform($data, $xsl, ())
};

declare function persons:view-item-request($node as node(), $model as map(*)){
    (: TODO: SIMPLFIY LATER :)
    (: `selected` is determined in app:determine_resource :)
    let $index := $model("selected")
    return
        persons:view-item($node, $model, $index)
};

declare function persons:list-items(){
    for $item in collection($config:data-persons)/tei:TEI
    return
        $item
};

declare
    %templates:wrap
function persons:missing-item($node as node(), $model as map(*)){
    let $index := $model("selected")
    let $data := collection($config:data-persons)//tei:person[@xml:id eq $index]
    return
        if (empty($data)) then
            <p class="alert alert-danger">
                Could not locate Person
                <b>{$index}</b>
            </p>
        else
            ()
};

(: Provide persons pagination :)
declare
    %templates:wrap
function persons:paging($node as node(), $model as map(*)){
    let $hits := persons:list-items()
    let $perpage := $app:perpage
    return
        app:pageination(
            $node,
            $model,
            $hits,
            $perpage
        )
};

declare
    %templates:wrap
function persons:countby_region($node as node(), $model as map(*), $region as xs:string) as xs:int{
    if ($region eq 'ar') then
        count(persons:list-items()//tei:category[@xml:id eq "ARMENIA"])
    else if ($region eq 'ge') then
        count(persons:list-items()//tei:category[@xml:id eq "GEORGIA"])
    else if ($region eq '') then
        count(persons:list-items())
    else
        -1
};

(: Display bibliography elements where editor contributed some changes. :)
declare function persons:edited-request($node as node(), $model as map(*)){
    (: `selected` is determined in app:determine_resource :)
    let $editor := $model("selected")
    let $data := <tei:listBibl>{bibl:list-items()}</tei:listBibl>
    let $data := $data//tei:TEI[contains(.//tei:author/@ref, $editor) or contains(.//tei:editor/@ref, $editor)]
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    let $parameters := <parameters>
        <param name="headline" value="Work"/>
    </parameters>
    return
        transform:transform($data, $xsl, $parameters)
};
