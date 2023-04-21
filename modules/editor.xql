xquery version "3.0";

module namespace editor="https://data.cobdh.org/editors";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace editors="https://data.cobdh.org/rest/editors" at "../rest/editors.xq";

import module namespace bibl="https://data.cobdh.org/bibl" at "bibl.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace templates="http://exist-db.org/xquery/templates";

declare function editor:index($node as node(), $model as map(*)){
    let $input := editors:list-items()
    let $xsl := config:resolve("views/editors/list-items.xsl")
    return
        transform:transform($input, $xsl, ())
};

declare function editor:view-item($node as node(), $model as map(*), $index as xs:string){
    let $index := $index cast as xs:string
    let $data := editors:list-items()/tei:TEI/tei:person[@xml:id eq $index]
    let $xsl := config:resolve("views/editors/view-item.xsl")
    return
        transform:transform($data, $xsl, ())
};

declare function editor:view-item-request($node as node(), $model as map(*)){
    (: `selected` is determined in app:determine_resource :)
    let $index := $model("selected")
    return
        editor:view-item($node, $model, $index)
};

declare
    %templates:wrap
function editor:missing-item($node as node(), $model as map(*)){
    let $index := $model("selected")
    let $data := editors:list-items()/tei:TEI/tei:person[@xml:id eq $index]
    return
        if (empty($data)) then
            <p class="alert alert-danger">
                Could not locate Editor
                <b>{$index}</b>
            </p>
        else
            ()
};

(: Display bibliography elements where editor contributed some changes. :)
declare function editor:edited-request($node as node(), $model as map(*)){
    (: `selected` is determined in app:determine_resource :)
    let $editor := $model("selected")
    let $data := <tei:listBibl>{bibl:list-items()}</tei:listBibl>
    let $data := $data//tei:TEI[contains(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/@ref, $editor)]/tei:body
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    let $parameters := <parameters>
        <param name="headline" value="Edited"/>
    </parameters>
    return
        transform:transform($data, $xsl, $parameters)
};
