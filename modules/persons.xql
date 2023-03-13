xquery version "3.0";

module namespace persons="https://data.cobdh.org/persons";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace templates="http://exist-db.org/xquery/templates" at "config.xqm";

import module namespace bibl="https://data.cobdh.org/bibl" at "bibl.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Global Variables:)
declare variable $persons:data := $config:app-root || "/data/persons";

declare function persons:index($node as node(), $model as map(*)){
    let $input := persons:list-items()
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        transform:transform($input, $xsl, ())
};

declare function persons:view-item($node as node(), $model as map(*), $index as xs:string){
    let $data := collection($persons:data)//tei:person[@xml:id eq $index]
    (: select root node to render header information :)
    let $data := $data/../..
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
    <tei:listPerson>
    {
        for $item in collection($persons:data)/tei:TEI
        return
            $item
    }
    </tei:listPerson>
};

declare
    %templates:wrap
function persons:missing-item($node as node(), $model as map(*)) {
    let $index := $model("selected")
    let $data := collection($persons:data)//tei:person[@xml:id eq $index]
    return
        if (empty($data)) then
            <p class="alert alert-danger">
                Could not locate Person
                <b>{$index}</b>
            </p>
        else
            ()
};

(: Display bibliography elements where editor contributed some changes. :)
declare function persons:edited-request($node as node(), $model as map(*)){
    (: `selected` is determined in app:determine_resource :)
    let $editor := $model("selected")
    let $data := bibl:list-items()//tei:TEI[contains(.//tei:author/@ref, $editor) or contains(.//tei:editor/@ref, $editor)]
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    return
        transform:transform($data, $xsl, ())
};
