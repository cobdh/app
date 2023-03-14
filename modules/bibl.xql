xquery version "3.0";

module namespace bibl="https://data.cobdh.org/bibl";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace templates="http://exist-db.org/xquery/templates" at "config.xqm";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Global Variables:)
declare variable $bibl:data := $config:app-root || "/data/bibl";

declare function bibl:index($node as node(), $model as map(*)){
    let $input := bibl:list-items()
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    return
        transform:transform($input, $xsl, ())
};

declare function bibl:view-item($node as node(), $model as map(*), $index as xs:string){
    let $data := collection($bibl:data)//(tei:biblFull|tei:biblStruct)[@xml:id eq $index]
    (: select root node to render header information :)
    let $data := $data/../..
    (: select template :)
    let $xsl := config:resolve("views/bibl/view-item.xsl")
    return
        transform:transform($data, $xsl, ())
};

declare function bibl:view-item-request($node as node(), $model as map(*)){
    (: TODO: SIMPLFIY LATER :)
    (: `selected` is determined in app:determine_resource :)
    let $index := $model("selected")
    return
        bibl:view-item($node, $model, $index)
};

declare function bibl:list-items(){
    (: Determine list of bibl, sort newest items first. :)
    <tei:listBibl>
    {
        for $item in collection($bibl:data)/tei:TEI
        order by $item//tei:date descending
        return
            $item
    }
    </tei:listBibl>
};

declare
    %templates:wrap
function bibl:missing-item($node as node(), $model as map(*)) {
    let $index := $model("selected")
    let $data := collection($bibl:data)//(tei:biblFull|tei:biblStruct)[@xml:id eq $index]
    return
        if (empty($data)) then
            <p class="alert alert-danger">
                <i18n:text key="bibl_record_missing">
                    Could not locate Bibliography
                </i18n:text>:
                <b>{$index}</b>
            </p>
        else
            ()
};
