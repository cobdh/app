xquery version "3.0";

module namespace bibl="https://data.cobdh.org/bibl";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

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

declare function bibl:view-item($node as node(), $model as map(*), $index as xs:integer){
    let $index := $index cast as xs:string
    let $data := collection($bibl:data)/tei:TEI/tei:biblFull[@xml:id eq $index]
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
    <tei:listBibl>
    {
        for $item in collection($bibl:data)/tei:TEI
        return
            $item
    }
    </tei:listBibl>
};
