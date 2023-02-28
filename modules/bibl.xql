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


declare function bibl:list-items(){
    <tei:listBibl>
    {
        for $item in collection($bibl:data)/tei:TEI
        return
            $item
    }
    </tei:listBibl>
};
